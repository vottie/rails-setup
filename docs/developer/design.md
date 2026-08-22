# 設計書

## 目的

Claude Code + GitHubを使ったRails開発の練習用アプリ。
POSTされた内容をそのままエコーして返す、最小構成のRails APIアプリ。

## 技術構成

- Rails 7.1(`--api` モード、フロントエンドビューなし)
- データベース: 未使用(永続化なし。全てリクエスト/レスポンスの中で完結)
- Webサーバー: Puma
- 認証: なし

## ディレクトリ構成(抜粋)

```
app/
  controllers/
    echo_controller.rb   # POSTされた内容をエコーするコントローラー
config/
  routes.rb               # ルーティング定義
```

## リクエスト/レスポンスの流れ

```
クライアント
  │  POST /echo  { "message": "..." }
  ▼
EchoController#create
  │  params[:message] を読み取り、そのままJSONで返却
  ▼
クライアント
  { "message": "..." }
```

## 今後の拡張方針(未実装)

- DB保存(ActiveRecord導入、投稿の一覧・履歴表示)
- バリデーション(空メッセージの拒否など)

## TBD(未決定・将来検討)

- **環境情報の自動化**: 現状 `docs/local/environments.md`(人間向けメモ、git管理外)と `.env`(Capistranoが読む実データ)が二重管理になっている。将来的にJSON/YAMLを正として `.env` を自動生成するスクリプト化を検討する。優先度低、現時点では着手しない。
