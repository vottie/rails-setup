# staging ステージ(テスト環境)
#
# サーバーのIP・ユーザー名・SSH鍵パスは、このファイルに直接書かない。
# .env (gitignore対象) に STAGING_HOST / STAGING_USER / STAGING_SSH_KEY_PATH を
# 設定してください。詳細は .env.example を参照。

server ENV.fetch("STAGING_HOST"),
       user: ENV.fetch("STAGING_USER"),
       roles: %w[app db web]

set :ssh_options, {
  keys: [ENV.fetch("STAGING_SSH_KEY_PATH")],
  forward_agent: true,
  auth_methods: %w[publickey]
}

set :branch, ENV.fetch("STAGING_BRANCH", "main")
set :rails_env, "staging"
