# Nature-Picture
自然風景の画像投稿アプリです<br>

# URL
https://www.naturepictureapp.com/ <br>
非ログイン状態の場合は投稿一覧のみ可能です。ログインすると記事投稿やコメントが可能になります。<br>
ログイン画面の「かんたんログイン」をクリックすると、メールアドレスとパスワードを入力せずにログインできます。

# 言語・使用技術
#### フロント
- slim
- Scss
- bootstrap4

#### バックエンド
- Ruby 2.5.1
- Ruby on Rails 5.2.3

#### サーバー
- Nginx 1.16.1

#### DB
- MySQL 5.5

#### インフラ・開発環境等
- AWS（VPC, EC2, S3, Route 53, ALB, ACM）
- Capistrano3
- RSpec

#### AWS構成図
![awskouseizu](https://user-images.githubusercontent.com/57769038/82515221-b1277c80-9b52-11ea-83b5-6f4dce1af4ac.png)

# 実装機能
- ユーザー機能
  - deviseを使用
  - 新規登録・ログイン・ログアウト機能
  - マイページ・登録情報編集機能
- 画像投稿機能
  - active_storageを使用
- コメント機能
- 検索機能
  - ransackを使用
- ページネーション機能
