class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prefectures_by_region, only: [:show]
  
  def show
    @tag = Tag.find(params[:id])
    @facility_type = params[:facility_type]
    @posts = @tag.posts
    # 施設タイプによる絞り込み
    if @facility_type.present?
      @posts = @posts.where(facility_type: @facility_type)
    end
    # ソートの適用
    if params[:latest]
      @posts = @posts.latest
    elsif params[:old]
      @posts = @posts.old
    elsif params[:highly_rated]
      @posts = @posts.highly_rated
    elsif params[:most_commented]
      @posts = @posts.most_commented
    else
      @posts = @posts.latest
    end
    # ページネーション
    @posts = @posts.page(params[:page]).per(8)
  end
  
  def create
    @tag = Tag.find_or_create_by(name: params[:name])
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
  end
  
  
  private
  
  # サイドバー用
  def set_prefectures_by_region
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
