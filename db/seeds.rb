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


puts "seedの作成が完了しました。"