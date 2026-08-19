# config valid for current version and patch releases of Capistrano
lock "~> 3.20.1"

# サーバーのIP・ユーザー名・SSH鍵などの機微情報は、このファイルや config/deploy/*.rb には書かない。
# 各自の .env (gitignore対象、.env.example を参照して作成) に書き、Dotenv経由でENVから読み込む。
require "dotenv"
Dotenv.load(".env")

set :application, "rails-setup"
set :repo_url, "https://github.com/vottie/rails-setup.git"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# デプロイ先のパスは環境変数で上書き可能(未指定時は /var/www/<application>/<stage>)
set :deploy_to, ENV.fetch("DEPLOY_TO") { "/var/www/#{fetch(:application)}/#{fetch(:stage)}" }

set :rbenv_type, :user
set :rbenv_ruby, File.read(".ruby-version").strip

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# master.keyはリポジトリに含まれないため、各サーバーの shared/config/master.key に
# 事前に手動配置しておく(scpなどで。Capistranoでは配布しない)
append :linked_files, "config/master.key"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
