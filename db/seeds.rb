# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create(email: "1@admin", password: '1qasw23ed')

user1 = User.find_or_create_by!(
  email: "anko@demo.com",
  name: "あんこ"
) do |user|
  user.password = "ankopass123"
end

user2 = User.find_or_create_by!(
  email: "zarame@demo.com",
  name: "ざらめ"
) do |user|
  user.password = "zaramepass123"
end

user3 = User.find_or_create_by!(
  email: "kinako@demo.com",
  name: "きなこ"
) do |user|
  user.password = "kinakopass123"
end

user4 = User.find_or_create_by!(
  email: "yukimi@demo.com",
  name: "ゆきみ"
) do |user|
  user.password = "yukimipass123"
end

post1 = Post.find_or_create_by!(title: "渋谷キッズパーク") do |post|
  post.address = "東京都渋谷区渋谷２丁目２１−１"
  post.postal_code = "150-8510"
  post.latitude = 35.659116
  post.longitude = 139.703727
  post.user = user1
  post.facility_type = "play"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/kids-park1.jpg"), filename: "kids-park1.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/kids-park2.jpg"), filename: "kids-park2.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/kids-park3.jpg"), filename: "kids-park3.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/kids-park4.jpg"), filename: "kids-park4.jpg" }
    ]
  )
end

post2 = Post.find_or_create_by!(title: "新宿ボールパーク") do |post|
  post.address = "東京都新宿区新宿３丁目１４−５"
  post.postal_code = "160-0022"
  post.latitude = 35.691470
  post.longitude = 139.704118
  post.user = user1
  post.facility_type = "play"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/ball-park1.jpg"), filename: "ball-park1.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/ball-park2.jpg"), filename: "ball-park2.jpg" }
    ]
  )
end

post3 = Post.find_or_create_by!(address: "東京都新宿区新宿３丁目１５−１７") do |post|
  post.title = "授乳室"
  post.postal_code = "160-0022"
  post.latitude = 35.692078
  post.longitude = 139.703728
  post.user = user2
  post.facility_type = "nursing_room"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/nursing_room1.jpg"), filename: "nursing_room1.jpg" }
    ]
  )
end

post4 = Post.find_or_create_by!(address: "東京都新宿区新宿３丁目１７−７") do |post|
  post.title = "おむつ替え"
  post.postal_code = "160-0022"
  post.latitude = 35.690921
  post.longitude = 139.700258
  post.user = user1
  post.facility_type = "diaper_changing_station"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/diaper_changing1.jpg"), filename: "diaper_changing1.jpg" }
    ]
  )
end

post5 = Post.find_or_create_by!(title: "代々木水族館") do |post|
  post.address = "東京都渋谷区代々木神園町２−１"
  post.postal_code = "151-0052"
  post.latitude = 35.672817
  post.longitude = 139.694496
  post.user = user2
  post.facility_type = "play"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/aquarium1.jpg"), filename: "aquarium1.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/aquarium2.jpg"), filename: "aquarium2.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/aquarium3.jpg"), filename: "aquarium3.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/aquarium4.jpg"), filename: "aquarium4.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/aquarium5.jpg"), filename: "aquarium5.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/aquarium6.jpg"), filename: "aquarium6.jpg" }
    ]
  )
end

post6 = Post.find_or_create_by!(address: "東京都渋谷区富ケ谷１丁目") do |post|
  post.title = "おむつ替え"
  post.postal_code = "151-0063"
  post.latitude = 35.669108
  post.longitude = 139.689967
  post.user = user2
  post.facility_type = "diaper_changing_station"
end

post7 = Post.find_or_create_by!(address: "東京都渋谷区代々木４丁目６") do |post|
  post.title = "授乳室"
  post.postal_code = "151-0053"
  post.latitude = 35.678957
  post.longitude = 139.693980
  post.user = user2
  post.facility_type = "nursing_room"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/nursing_room2.jpg"), filename: "nursing_room2.jpg" }
    ]
  )
end

post8 = Post.find_or_create_by!(address: "北海道札幌市東区丘珠町５６９−２８") do |post|
  post.title = "おむつ替え"
  post.postal_code = "007-0880"
  post.latitude = 43.116051
  post.longitude = 141.410553
  post.user = user4
  post.facility_type = "diaper_changing_station"
end

post9 = Post.find_or_create_by!(title: "札幌動物園") do |post|
  post.address = "北海道札幌市東区丘珠町５８４−２"
  post.postal_code = "007-0880"
  post.latitude = 43.116522
  post.longitude = 141.413427
  post.user = user4
  post.facility_type = "play"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/zoo1.jpg"), filename: "zoo1.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/zoo2.jpg"), filename: "zoo2.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/zoo3.jpg"), filename: "zoo3.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/zoo4.jpg"), filename: "zoo4.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/nursing_room1.jpg"), filename: "nursing_room1.jpg" }
    ]
  )
end

post10 = Post.find_or_create_by!(title: "なかの公園") do |post|
  post.address = "東京都中野区中野２丁目５"
  post.postal_code = "164-0001"
  post.latitude = 35.703976
  post.longitude = 139.671269
  post.user = user1
  post.facility_type = "play"
  post.images.attach(
    [
      { io: File.open("#{Rails.root}/db/fixtures/water1.jpg"), filename: "water1.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/water2.jpg"), filename: "water2.jpg" },
      { io: File.open("#{Rails.root}/db/fixtures/water3.jpg"), filename: "water3.jpg" }
    ]
  )
end

tag1 = Tag.find_or_create_by!(name: "0〜1歳")
tag2 = Tag.find_or_create_by!(name: "1〜2歳")
tag3 = Tag.find_or_create_by!(name: "2〜4歳")
tag4 = Tag.find_or_create_by!(name: "4〜6歳")
tag5 = Tag.find_or_create_by!(name: "6歳以上")
tag6 = Tag.find_or_create_by!(name: "ベビーカー貸出")
tag7 = Tag.find_or_create_by!(name: "イートインスペース")
tag8 = Tag.find_or_create_by!(name: "ベビーチェア")
tag9 = Tag.find_or_create_by!(name: "授乳室")
tag10 = Tag.find_or_create_by!(name: "調乳用のお湯")
tag11 = Tag.find_or_create_by!(name: "おむつ替")
tag12 = Tag.find_or_create_by!(name: "おむつ用ごみ箱")
tag13 = Tag.find_or_create_by!(name: "授乳室女性限定")
tag14 = Tag.find_or_create_by!(name: "個室以外は男性OK")
tag15 = Tag.find_or_create_by!(name: "キッズトイレ")
tag16 = Tag.find_or_create_by!(name: "補助便座")
tag17 = Tag.find_or_create_by!(name: "電子レンジ")
tag18 = Tag.find_or_create_by!(name: "自動販売機")

post1.tags << [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10, tag11, tag12, tag14, tag15, tag17]
post2.tags << [tag3, tag4, tag5, tag7, tag8, tag9, tag11, tag12, tag14, tag15, tag17, tag18]
post3.tags << [tag9, tag10, tag11, tag12, tag13, tag16, tag17, tag18]
post4.tags << [tag11, tag12]
post5.tags << [tag2, tag3, tag4, tag5, tag7, tag8, tag9, tag11, tag12, tag14, tag16, tag18]
post6.tags << [tag11, tag12]
post7.tags << [tag9, tag10, tag11, tag12, tag13, tag16, tag18]
post8.tags << [tag11, tag12, tag18]
post9.tags << [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10, tag11, tag12, tag14, tag18]
post10.tags << [tag2, tag3, tag4, tag5, tag11, tag18]

comment1 = post1.comments.find_or_create_by!(
  content: "2歳未満のエリアもあり小さい子も安心して遊べます。\nお湯や電子レンジもあるので助かります。",
  user: user1
)

comment2 = post2.comments.find_or_create_by!(
  content: "広いので子どもたちも大喜びでした！",
  user: user1
)

comment3 = post3.comments.find_or_create_by!(
  content: "綺麗で使いやすいです",
  user: user2
)

comment4 = post2.comments.find_or_create_by!(
  content: "週末はかなり混みますが、平日は空いていておすすめです",
  user: user3
)

comment5 = post5.comments.find_or_create_by!(
  content: "シャチのショーがあり大人も子供も楽しめます",
  user: user2
)

comment6 = post5.comments.find_or_create_by!(
  content: "中はベビーカーも通りやすくなっているので小さい子連れにもおすすめです",
  user: user1
)

comment7 = post5.comments.find_or_create_by!(
  content: "夏は涼しいです",
  user: user3
)

comment8 = post7.comments.find_or_create_by!(
  content: "個室が少し狭いと思いました",
  user: user2
)

comment9 = post9.comments.find_or_create_by!(
  content: "動物が間近で見れて子どもも興味津々でした。\n夏休みは家族連れが多いです。",
  user: user4
)

comment10 = post10.comments.find_or_create_by!(
  content: "水場があり水遊びが楽しめる公園です",
  user: user1
)

comment1.ratings.find_or_create_by!(score: 5, user: user1)
comment2.ratings.find_or_create_by!(score: 4, user: user1)
comment3.ratings.find_or_create_by!(score: 4, user: user2)
comment4.ratings.find_or_create_by!(score: 5, user: user3)
comment5.ratings.find_or_create_by!(score: 5, user: user2)
comment6.ratings.find_or_create_by!(score: 5, user: user1)
comment7.ratings.find_or_create_by!(score: 4, user: user3)
comment8.ratings.find_or_create_by!(score: 3, user: user2)
comment9.ratings.find_or_create_by!(score: 4, user: user4)
comment10.ratings.find_or_create_by!(score: 4, user: user1)