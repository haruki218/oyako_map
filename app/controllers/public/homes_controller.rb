class Public::HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  def top
  end

  def main
    @posts = Post.where(facility_type: "play").order(created_at: :desc).limit(3)
    @commented_posts = Post.most_commented.limit(3)
    @prefectures_by_region = {
      "北海道/東北" => ["北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県"],
      "関東" => ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県"],
      "中部" => ["新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県"],
      "近畿" => ["三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"],
      "中国/四国" => ["鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県"],
      "九州/沖縄" => ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
    }
  end
end
