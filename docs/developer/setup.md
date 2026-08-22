# セットアップガイド

## 前提環境

- Ruby 3.1.2 (`.ruby-version` 参照)
- Rails 7.1系
- SQLite3
- Bundler

## 手順

```bash
git clone https://github.com/vottie/rails-setup.git
cd rails-setup
bundle install
```

## サーバー起動

```bash
rails server
# または別ターミナルを使わずバックグラウンド起動する場合
rails server &
```

起動後、`http://localhost:3000` で待ち受けます。

## 動作確認

```bash
curl -X POST http://localhost:3000/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

`{"message":"hello"}` が返れば成功です。

## Dockerでの起動

```bash
docker build -t rails-setup .
docker run -p 3000:3000 rails-setup
```

## デプロイ環境(Capistrano)のセットアップ

development / staging / production の3ステージを [Capistrano](https://capistranorb.com/) で管理する。
サーバーのIP・ユーザー名・SSH鍵パスは**リポジトリにコミットしない**ため、各自ローカルで `.env` を用意する。

```bash
cp .env.example .env
# .env を開き、各ステージの HOST / USER / SSH_KEY_PATH を記入する
```

`.env` は `.gitignore` 対象。誤ってコミットしないよう注意すること。

### デプロイ先サーバー側の前提

- rbenvで `.ruby-version` と同じRubyバージョンが使えること
- デプロイ用ユーザーが `deploy_to` 先ディレクトリに書き込めること
- `shared/config/master.key` を事前に手動配置しておくこと(Capistranoでは配布しない)

### デプロイの実行

```bash
bundle exec cap development deploy   # 開発環境
bundle exec cap staging deploy       # テスト環境
bundle exec cap production deploy    # 本番環境
```

初回のみ、共有ディレクトリ構成を作成する:

```bash
bundle exec cap <stage> deploy:check
```
