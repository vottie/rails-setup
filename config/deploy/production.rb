# production ステージ(本番環境: サクラVPS)
#
# サーバーのIP・ユーザー名・SSH鍵パスは、このファイルに直接書かない。
# .env (gitignore対象) に PRODUCTION_HOST / PRODUCTION_USER / PRODUCTION_SSH_KEY_PATH を
# 設定してください。詳細は .env.example を参照。

server ENV.fetch("PRODUCTION_HOST"),
       user: ENV.fetch("PRODUCTION_USER"),
       roles: %w[app db web]

set :ssh_options, {
  keys: [ENV.fetch("PRODUCTION_SSH_KEY_PATH")],
  forward_agent: true,
  auth_methods: %w[publickey]
}

# 本番は明示的にタグ/mainのみを想定し、うっかりブランチデプロイしないようにする
set :branch, ENV.fetch("PRODUCTION_BRANCH", "main")
set :rails_env, "production"

# 本番デプロイ前に必ず確認を挟む
set :ask_for_confirmation_before_destructive_action, true
