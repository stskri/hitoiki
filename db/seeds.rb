# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedを作成します。"

# adminの設定
Admin.find_or_create_by(id: 1) do |admin|
  admin.email = 'a@a'
  admin.password = 'aaaaaa'
  admin.password_confirmation = 'aaaaaa'
end
# adminの設定ここまで

# userの設定
user_ids = (1..25)
names = ("A".."Z").to_a.reject { |letter| letter == "A" }.map { |letter| letter * 2 }

user_ids.zip(names).each do |user_id, name|
  User.find_or_create_by(id: user_id) do |user|
    user.name = name
    user.email = "#{name[0].downcase}@#{name[0].downcase}"
    user.password = name[0].downcase * 6
  end
end
# userの設定ここまで

# Postの設定
30.times do |i|
  Post.create(
    user_id: rand(1..25),
    body: "投稿テスト#{i + 1}"
  )
end
# Postの設定ここまで

# emotionの設定
emotions = [
  { id: 1, name: '安心', color: '#aed581' },   # ライトグリーン
  { id: 2, name: '楽しい', color: '#81c784' }, # パステルグリーン
  { id: 3, name: '希望', color: '#4fc3f7' },   # スカイブルー
  { id: 4, name: '哀しい', color: '#64b5f6' }, # パステルブルー
  { id: 5, name: '驚き', color: '#ce93d8' },   # パステルパープル
  { id: 6, name: '体調不良', color: '#ba68c8' }, # ディープパープル
  { id: 7, name: '喜び', color: '#fff176' },   # パステルイエロー
  { id: 8, name: '恐れ', color: '#ffb74d' },   # パステルオレンジ
  { id: 9, name: '怒り', color: '#ff8a80' },   # パステルレッド
  { id: 10, name: '興奮', color: '#f06292' },  # ビビッドピンク
  { id: 11, name: '孤独', color: '#90a4ae' },  # クールグレー
  { id: 12, name: '絶望', color: '#424242' }   # ダークグレー
]
emotions.each do |emotion_data|
  Emotion.find_or_create_by(id: emotion_data[:id]) do |emotion|
    emotion.name = emotion_data[:name]
    emotion.color = emotion_data[:color]
  end
end
# emotionの設定ここまで


puts "seedの作成が完了しました。"