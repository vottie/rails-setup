# トラブルシューティングガイド

## `bundle install` が失敗する

- `ruby -v` で `.ruby-version` に記載のバージョンと一致しているか確認する。
- `bundle check` で不足しているgemを確認する。

## サーバーが起動しない・ポートが使用中と言われる

```bash
lsof -i :3000
kill <PID>
```

別ポートで起動したい場合:

```bash
rails server -p 3001
```

## curlで接続できない(Connection refused)

- `rails server` が起動しているか確認する。
- Dockerで動かしている場合、`-p 3000:3000` でポートを公開しているか確認する。

## `{"message": null}` が返ってくる

リクエストの `Content-Type: application/json` ヘッダーが抜けている可能性が高い。ヘッダーを付けてJSON形式で送信すること。

```bash
curl -X POST http://localhost:3000/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

## master.keyがない、credentialsが復号できない

`config/master.key` は `.gitignore` 対象でリポジトリに含まれない。開発環境を新しく用意する場合は、鍵を持つメンバーから共有してもらうか、`rails credentials:edit` で作り直す。
