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

# emotionの設定
emotions = [
  { id: 1, name: '喜び', color: '#fff9c4' },
  { id: 2, name: '怒り', color: '#ffcdd2' },
  { id: 3, name: '哀しい', color: '#bbdefd' },
  { id: 4, name: '楽しい', color: '#c8e6c9' }
]

emotions.each do |emotion_data|
  Emotion.find_or_create_by(id: emotion_data[:id]) do |emotion|
    emotion.name = emotion_data[:name]
    emotion.color = emotion_data[:color]
  end
end
# emotionの設定ここまで


puts "seedの作成が完了しました。"