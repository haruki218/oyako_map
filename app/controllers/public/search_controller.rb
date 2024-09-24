class Public::SearchController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prefectures_by_region
  
  def index
    @model = params[:model]
    @content = params[:content]
    @facility_type = params[:facility_type] # 絞り込み用のfacility_type
    
    if @model == "user"
      @records = User.search_for(@content).page(params[:page]).per(8) # ページネーション
    elsif @model == "post"
      @records = Post.search_for(@content)
      # 検索結果に対して絞り込み
      if @facility_type.present?
        @records = @records.where(facility_type: @facility_type)
      end
      # ソートの適用
      if params[:latest]
        @records = @records.latest
      elsif params[:old]
        @records = @records.old
      elsif params[:highly_rated]
        @records = @records.highly_rated
      elsif params[:most_commented]
        @records = @records.most_commented
      else
        @records = @records.latest
      end
      # ページネーション
      @records = @records.page(params[:page]).per(8)
    end
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
