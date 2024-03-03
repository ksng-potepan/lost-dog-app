# 迷子犬掲示板「ドッグル」

このwebサイトは、迷子犬の情報共有を目的とした掲示板です。  
飼い犬が迷子になったり、迷子犬を保護したり、目撃した情報を共有できます。  
DM機能を備えているのでユーザー同士のやり取りが可能です。  

<img width="491" alt="トップロゴ" src="https://github.com/ksng-potepan/lost-dog-app/assets/125693644/018ad6ae-0f3a-48ba-bec0-6666f38e8b8e">

## サイトへの想い
現在、迷子犬の情報共有には、複数のサイトに情報を登録する必要があり、手間がかかってしまいます。  
また、サイトによって情報が偏ってしまい、探しにくくなってしまうという課題があります。  
迷子犬の情報共有を円滑にし早期発見することを目指したいという思いで作成しました。

目撃情報をマップで表示することで、迷子犬の周辺の情報を簡単に確認できるようにしています。  
また、保護できない場合の連絡先を記載することで、速やかに迎えに行けることを促します。

今後も機能の拡充やサービスの改善に取り組んで、迷子犬の情報共有といえば **「ドッグル」** になるよう実現を目指します。

## 使用技術
- Ruby 3.2.2p53
- Rails 7.0.7.2
- PostgreSQL 1.5.4
- Fly.io
- Docker
- GitHub Actions
- RSpec
- Capybara
- Rubocop
- Maps JavaScript API


### 構図
![システム構成図 drawio](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/ac034555-457f-49dc-88a1-79e16c26e2df)

### ER図
![迷子犬ER図](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/4e40bcb7-6232-4d0c-a0ea-f137908dafa7)

## 機能一覧

| 機能名 | 説明 |
----|---- 
| ログイン機能	 | サインアップ・サインイン・ログアウト |
| プロフィール機能 | プロフィール情報の編集　|
| 掲示板投稿機能 | 迷子犬について投稿　|
| 掲示板検索機能 | 迷子犬について検索 |
| 絞り込み表示機能 | 長期で預かれない投稿だけを一覧表示 |
| 目撃情報の投稿機能 | 目撃した迷子犬を投稿 |
| DM機能 | ユーザー同士での連絡 |

## 機能紹介
### TOPページ
当サイトの概要と、目撃情報を新着３件表示しています。  
![TOPページ](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/d5a2284c-1a87-4536-9e21-3f7bcfd5e96b)

### ログインページ
[devise](https://github.com/heartcombo/devise)を使用したログイン機能です。ゲストログイン、メールアドレスログインを実装。  
![ログインページ](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/570866ed-fd6f-46b7-b378-4c4b33371cfe)

### マイページ

__ゲスト__
* 編集機能は利用できません。
* 編集したい場合は、ログインまたは新規登録が必要です。

![ゲストマイページ](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/e1b8fe40-1a25-4070-be9b-10c7b5d7c74c)

__登録したユーザー__  
* 編集したい項目のリンクをクリックすることで、編集画面に遷移できます。  
* 編集画面では、項目内容の変更や削除を行うことができます。

![ユーザーマイページ](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/a7bf9346-ad12-4bef-ba26-29d09700981b)

### 掲示板への投稿
迷子犬を探している方、保護した方、目撃した方のための掲示板です。　　  
投稿にあたり注意喚起のページも挟んでいます。  
![投稿](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/39280f43-cfa8-4c9b-8942-677af75fa747)
![注意喚起](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/da8383df-9b6c-42ad-82bd-e00aece2ce86)

__迷子犬__  
![迷子犬１](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/3435b7fe-851a-49a3-8010-e0fdd4362162)
![迷子犬２](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/16e72a8c-5d96-4e0a-ace5-69a4aeb77782)

__保護犬__  
![保護犬１](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/2c7a5c86-ce4f-4531-b7ae-cab082dbcbaf)
![保護犬２](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/9f3bae6a-c7d1-4d94-9f84-4eeeb63edb05)
![保護犬３](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/61f47446-9fac-43bd-b794-84f802c9bd67)

__目撃情報__  
![目撃情報](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/39e4f944-059c-4069-bb24-c83fb862fdf5)

### 検索機能
![検索機能](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/c8daad40-2e12-4444-8aed-6ae2efca2de7)

### 投稿一覧表示
__迷子犬__  
![迷子犬](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/676fb489-f5ed-4ef7-8bf1-dda5ac0b2579)


__保護犬__  
![保護犬](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/2db72c70-ccdf-4396-85c8-8b15e93285c0)

__一時お預かり__  
![一時お預かり](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/c711f559-c084-4e8f-8265-c205436ce6c7)

__目撃情報マップ__  
![スクリーンショット 2024-03-03 19 41 58](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/d94c0b6d-aafd-4a4f-b5c1-0cd3e81d0260)


### DM機能
ユーザー同士でやり取りが可能です。  
![DM](https://github.com/ksng-potepan/lost-dog-app/assets/125693644/5865c94a-a3b0-4d57-a939-d72c887ecc34)

## 今後実装していくこと
- AI画像検索
- 掲示板の並べ替え機能
- DMの通知機能
- DM内の画像や動画の添付
- 画像複数投稿機能
