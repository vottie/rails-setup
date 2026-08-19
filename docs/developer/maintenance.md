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

## ステージング環境について

本番(Sakura VPS)の前段として、ステージング環境での確認を推奨する。
候補: 同一VPS内の別ポート/別ディレクトリへのデプロイ、またはOCIの無料枠インスタンスなど。
現状このリポジトリにはステージング/本番用のCapistrano設定は未整備のため、導入時は別途ドキュメント化すること。
