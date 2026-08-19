# 公開API仕様

## POST /echo

送信した `message` をそのまま返す。

### リクエスト

| 項目 | 内容 |
|---|---|
| メソッド | POST |
| パス | `/echo` |
| Content-Type | `application/json` |

```json
{ "message": "hello" }
```

### レスポンス

- ステータス: `200 OK`
- Content-Type: `application/json`

```json
{ "message": "hello" }
```

### 例

```bash
curl -X POST http://localhost:3000/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

### 補足

- `message` を指定しない場合、`{"message": null}` が返る(現状バリデーションなし)。
- 認証は不要。

## GET /up

ヘルスチェック用エンドポイント。アプリが正常に起動していれば `200`、例外が発生していれば `500` を返す。ロードバランサや死活監視から利用する想定。

```bash
curl -I http://localhost:3000/up
```
