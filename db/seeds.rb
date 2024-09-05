# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Tag.create([
  { name: '0〜1歳' },
  { name: '1〜2歳' },
  { name: '2〜4歳' },
  { name: '4〜6歳' },
  { name: '6歳以上' },
  { name: 'ベビーカー貸出' },
  { name: 'イートインスペース' },
  { name: 'ベビーチェア' },
  { name: '授乳室' },
  { name: '調乳用のお湯' },
  { name: 'おむつ替え' },
  { name: 'おむつ用ごみ箱' },
  { name: '女性限定' },
  { name: '個室以外は男性OK' }
])