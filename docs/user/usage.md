# 使い方

このアプリは、送信した内容をそのまま返す(エコーする)だけのシンプルなAPIです。

## 基本的な使い方

`/echo` に対して、`message` というキーで内容を送信します。

```bash
curl -X POST http://localhost:3000/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"こんにちは"}'
```

送信した内容がそのまま返ってきます。

```json
{ "message": "こんにちは" }
```

## 動作確認(サービスが起動しているか)

```bash
curl -I http://localhost:3000/up
```

`200 OK` が返れば正常に動作しています。
