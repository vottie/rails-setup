# メンテナンスガイド

## 依存関係の更新

```bash
bundle outdated       # 更新可能なgemを確認
bundle update <gem名>  # 個別に更新(まとめてのbundle updateは非推奨)
```

更新後は必ずローカルで動作確認してからコミットする。

## サーバーの再起動

```bash
kill %1        # `rails server &` で起動した場合
# または
lsof -i :3000  # PIDを確認して
kill <PID>
```

## ログの確認

```bash
tail -f log/development.log   # 開発環境
tail -f log/production.log    # 本番環境
```

## デプロイ前チェックリスト

- [ ] `bundle install` がエラーなく通る
- [ ] ローカルでcurlによる動作確認が取れている
- [ ] `git status` でコミット漏れがない
- [ ] (該当する場合)ステージング環境での確認が済んでいる

## 環境構成(development / staging / production)

Capistranoで3ステージを管理している(設定は `config/deploy.rb`, `config/deploy/*.rb`)。
サーバーのIP・ユーザー名・SSH鍵パスは `.env`(gitignore対象)で管理し、リポジトリには一切含めない。
セットアップ手順は [setup.md](./setup.md#デプロイ環境capistranoのセットアップ) を参照。

### デプロイの流れ

1. `develop` 相当のブランチで動作確認
2. `bundle exec cap staging deploy` でステージング(テスト環境)に反映して確認
3. 問題なければ `main` にマージし、`bundle exec cap production deploy` で本番反映

### ロールバック

```bash
bundle exec cap production deploy:rollback
```
