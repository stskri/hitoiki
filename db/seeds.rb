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
names = ("A".."Z").to_a.reject { |letter| letter == "A" }.map { |letter| "#{letter * 2}name" }

user_ids.zip(names).each do |user_id, name|
  User.find_or_create_by(id: user_id) do |user|
    user.name = name
    user.email = "#{name[0].downcase}@#{name[0].downcase}"
    user.password = name[0].downcase * 6
  end
end
# userの設定ここまで

# Postの設定
80.times do |i|
  Post.create(
    user_id: rand(1..25),
    body: "投稿テスト#{i + 1}"
  )
end
# Postの設定ここまで

# emotionの設定
emotions = [
  { id: 1, name: '喜び', color: '#fff176' },
  { id: 2, name: '安心', color: '#aed581' },
  { id: 3, name: '楽しい', color: '#6fab6c' },
  { id: 4, name: '希望', color: '#4fc3f7' },
  { id: 5, name: '哀しい', color: '#3a91c8' },
  { id: 6, name: '驚き', color: '#bf8cdc' },
  { id: 7, name: '体調不良', color: '#9c4db5' },
  { id: 8, name: '興奮', color: '#f48fb1' },
  { id: 9, name: '怒り', color: '#ff4040' },
  { id: 10, name: '恐怖', color: '#b71c1c' },
  { id: 11, name: '孤独', color: '#90a4ae' },
  { id: 12, name: '絶望', color: '#424242' }
]
emotions.each do |emotion_data|
  Emotion.find_or_create_by(id: emotion_data[:id]) do |emotion|
    emotion.name = emotion_data[:name]
    emotion.color = emotion_data[:color]
  end
end
# emotionの設定ここまで


puts "seedの作成が完了しました。"