# ローカル専用ドキュメント

このディレクトリは **gitで追跡しません**(`.gitignore`参照)。
実際のサーバーIP・ユーザー名・SSHキーのパスなど、公開リポジトリに書くべきでない情報はここに置きます。

追跡されるのはこの`README.md`と`*.example`(テンプレート)だけです。

## 使い方

```bash
cp docs/local/environments.md.example docs/local/environments.md
# environments.md に実際の値を記入する
```

`environments.md` はgit管理外なので、消えても他の人には共有されません。
各自のマシンで作成し、必要なら安全な方法(パスワードマネージャーなど)で他のメンバーと共有してください。
