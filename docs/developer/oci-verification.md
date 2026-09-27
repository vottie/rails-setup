# OCI(ステージング)での動作検証手順

本番(サクラVPS)へデプロイする前に、OCI(Oracle Cloud Infrastructure) Always Freeインスタンスを
ステージング環境として動作確認する手順。実際のホスト名・IP・ユーザー名は
[../local/environments.md](../local/environments.md)(git管理外)を参照。

## 前提: インスタンス仕様

- 1 OCPU / メモリ1GB(Always Free枠)
- 参考: [メンテナンスガイド](./maintenance.md)、[トラブルシューティングガイド](./troubleshooting.md)

## 0. アーキテクチャの確認

OCIのAlways Freeには x86(`VM.Standard.E2.1.Micro`)とArm(Ampere A1)の2種類がある。
本番(サクラVPS)と揃っているか確認しておく。

```bash
ssh <staging-user>@<staging-host> uname -m
# x86_64 ならサクラVPSと同一系統
# aarch64 なら Arm。Dockerイメージやgemのネイティブ拡張の挙動に差が出ないか注意
```

## 1. swap設定(OOM対策)

1GB RAMは `bundle install` や `docker build` の途中でOOM Killerに落とされることがあるため、
最初にswapを用意する。

```bash
ssh <staging-user>@<staging-host>

# 2GBのswapファイルを作成
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 再起動後も有効になるよう永続化
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 確認
free -h
```

## 2. ファイアウォールの開放(二重構成に注意)

OCIは **コンソール側の Security List / NSG** と **インスタンス内の `iptables`/`firewalld`** の
両方で塞がれているため、片方だけ開けても繋がらない。

### 2-1. コンソール側(Security List または NSG)

OCIコンソール → 該当VCN → Security List(またはNetwork Security Group)で、
アプリ用ポート(例: 3000番)とSSH(22番)のIngress Ruleを開ける。

### 2-2. インスタンス内側

```bash
# firewalldの場合
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload

# iptablesの場合
sudo iptables -I INPUT -p tcp --dport 3000 -j ACCEPT
sudo netfilter-persistent save   # ディストリによって永続化コマンドは異なる
```

## 3. サーバー側の事前準備

```bash
# rbenvでRubyをセットアップ(.ruby-versionと同じバージョン)
ssh <staging-user>@<staging-host>
rbenv install 3.1.2   # 既に入っていればスキップ
rbenv global 3.1.2

# デプロイ用ディレクトリの親を作成(Capistranoがshared/releasesを掘る)
sudo mkdir -p /var/www/rails-setup
sudo chown <staging-user>:<staging-user> /var/www/rails-setup
```

`config/master.key` はリポジトリに含まれず、Capistranoでも配布しないため、
`shared/config/master.key` に事前に手動配置しておく(ローカルからscpなど)。

```bash
ssh <staging-user>@<staging-host> mkdir -p /var/www/rails-setup/staging/shared/config
scp config/master.key <staging-user>@<staging-host>:/var/www/rails-setup/staging/shared/config/master.key
```

## 4. ローカル側の準備

```bash
cp .env.example .env
# .env に STAGING_HOST / STAGING_USER / STAGING_SSH_KEY_PATH を記入
```

## 5. デプロイ実行

```bash
bundle exec cap staging deploy:check   # 共有ディレクトリ構成の初回チェック
bundle exec cap staging deploy
```

## 6. 動作確認

```bash
curl -I http://<staging-host>:3000/up

curl -X POST http://<staging-host>:3000/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"hello from oci staging"}'
```

`{"message":"hello from oci staging"}` が返れば成功。

## うまくいかない時は

- ポートに繋がらない → 手順2(二重ファイアウォール)を再確認
- `bundle install`や`assets`系タスクで固まる/落ちる → `free -h`でswapが有効か確認
- SSH接続自体に失敗する → `.env`の`STAGING_SSH_KEY_PATH`と鍵の権限(`chmod 600`)を確認

## ロールバック

```bash
bundle exec cap staging deploy:rollback
```
