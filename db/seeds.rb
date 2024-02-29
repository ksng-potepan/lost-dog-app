# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars", { name: "Lord of the Rings"])
#   Character.create(name: "Luke", movie: movies.first)

# テスト用ユーザーの作成
User.create!(
  username: 'テスト太郎',
  email: 'taro@example.com',
  password: '123456',
  password_confirmation: '123456',
  id: 1
)

User.create!(
  username: 'テスト花子',
  email: 'hanako@example.com',
  password: '111111',
  password_confirmation: '111111',
  id: 2
)

User.create!(
  username: 'ゲスト',
  email: 'guest@example.com',
  password: '111111',
  password_confirmation: '111111',
  id: 3
)

# テスト用投稿データ作成
Amble.create!(
  name: "Amble",
  breed:"柴犬",
  size: "小型",
  gender: "不明",
  color:"茶色",
  age: "2歳",
  features: "人懐っこい",
  tag: true,
  chip: true,
  date: "2000/11/01",
  time: "13:00",
  prefecture: "東京都",
  municipalities: "渋谷区",
  area: "渋谷駅前",
  situation:"散歩中に",
  notification: "保健所",
  user_id: 1
)

Amble.create!(
  name: "AMBLE",
  breed:"豆柴",
  size: "小型",
  gender: "不明",
  color:"黒色",
  age: "4歳",
  features: "甘えん坊",
  tag: true,
  chip: true,
  date: "2000/11/11",
  time: "夕方",
  prefecture: "東京都",
  municipalities: "渋谷区",
  area: "ハチ公前",
  situation:"散歩中に",
  notification: "警察署",
  user_id: 2
)

Amble.create!(
  name: "まいご",
  breed: "ダックスフンド",
  size: "小型",
  gender: "不明",
  color: "茶色",
  age: "6歳",
  features: "破天荒",
  tag: false,
  chip: false,
  date: "2011/10/10",
  time: "11:11",
  prefecture: "東京都",
  municipalities: "渋谷区",
  area: "スクランブル交差点",
  situation:"移動中に",
  notification: "保健所",
  user_id: 3
)

Protect.create!(
  name: "Protect",
  breed:"チワワ",
  size: "小型",
  gender: "不明",
  color:"白色",
  age: "4歳",
  features: "かわいい",
  tag: true,
  chip: true,
  date: "2000/11/11",
  time: "13:00",
  prefecture: "北海道",
  municipalities: "札幌市",
  area: "札幌駅前",
  situation:"散歩中に",
  notification: "保健所",
  transferred: false,
  location: nil,
  user_id: 1
)

Protect.create!(
  name: "ferred",
  breed:"ポメラニアン",
  size: "小型",
  gender: "不明",
  color:"茶色",
  age: "1歳",
  features: "破天荒",
  tag: true,
  chip: true,
  date: "2000/11/11",
  time: "11:11",
  prefecture: "東京都",
  municipalities: "渋谷区",
  area: "ハチ公前",
  situation:"散歩中に",
  notification: "警察署",
  transferred: true,
  location: "近所の〇〇さん宅",
  user_id: 2
)

Protect.create!(
  name: "ほご",
  breed: "マルチーズ",
  size: "小型",
  gender: "不明",
  color: "白色",
  age: "不明",
  features: "おとなしい",
  tag: false,
  chip: false,
  date: "2011/10/10",
  time: "11:11",
  prefecture: "東京都",
  municipalities: "渋谷区",
  area: "スクランブル交差点",
  situation: "移動中に",
  notification: "保健所",
  transferred: true,
  location: "自治体の保健所",
  user_id: 3
)

Sighting.create!(
  user_id: 1,
  date: "2000/11/11",
  time: "正午",
  area: "ハチ公前",
  situation: "走って行った",
  lat: 35.65876,
  lng: 139.701069
)

Sighting.create!(
  user_id: 2,
  date: "2000/10/10",
  time: "早朝",
  area: "大阪城",
  situation: "草の上で寝ていた",
  lat: 34.687257,
  lng: 135.525855
)

Sighting.create!(
  user_id: 3,
  date: "2000/09/20",
  time: "15:00ごろ",
  area: "名古屋駅",
  situation: "キョロキョロとしていた",
  lat: 35.170915,
  lng: 136.881537
)

# テスト用DMデータ
Room.create!(
  user_id: 1,
  id: 10
)

Entry.create!(
  user_id: 1,
  room_id: 10
)

Entry.create!(
  user_id: 3,
  room_id: 10
)

Message.create!(
  user_id: 1,
  room_id: 10,
  message: "見つかりました！"
)

Message.create!(
  user_id: 3,
  room_id: 10,
  message: "良かったです"
)

Message.create!(
  user_id: 1,
  room_id: 10,
  message: "ありがとうございました"
)
