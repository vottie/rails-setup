# development ステージ
#
# サーバーのIP・ユーザー名・SSH鍵パスは、このファイルに直接書かない。
# .env (gitignore対象) に DEVELOPMENT_HOST / DEVELOPMENT_USER / DEVELOPMENT_SSH_KEY_PATH を
# 設定してください。詳細は .env.example を参照。

server ENV.fetch("DEVELOPMENT_HOST"),
       user: ENV.fetch("DEVELOPMENT_USER"),
       roles: %w[app db web]

set :ssh_options, {
  keys: [ENV.fetch("DEVELOPMENT_SSH_KEY_PATH")],
  forward_agent: true,
  auth_methods: %w[publickey]
}

set :branch, ENV.fetch("DEVELOPMENT_BRANCH", "main")
set :rails_env, "development"
