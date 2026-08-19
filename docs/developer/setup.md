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
