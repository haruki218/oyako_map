class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_guest_user, only: [:new, :new_play, :new_facility, :create, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_prefectures_by_region, only: [:index]
  
  def new
  end

  def new_play
    @post = Post.new
    @comment = Comment.new
  end

  def new_facility
    @post = Post.new
  end

  def index
    @facility_type = params[:facility_type]
    # 施設タイプによる絞り込み
    @posts = Post.all
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

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @rating = Rating.new
    # ページネーション
    @images = @post.images.page(params[:page]).per(3)
  end

  def create
    @post = current_user.posts.build(post_params)
    # 設備の投稿時にfacility_typeを設定
    if params[:facility_type].present?
      @post.facility_type = params[:facility_type]
      @post.title = facility_title(params[:facility_type])
    # 遊び場の投稿時にfacility_typeをplayに設定
    elsif @post.facility_type.blank?
      @post.facility_type = 'play'
    end
    # タグが1つ以上選択されているか確認
    if params[:post][:tag_ids].blank?
      flash[:alert] = '少なくとも1つのタグを選択してください'
      redirect_back(fallback_location: root_path) and return
    end
    if @post.save
      @post.tags = Tag.where(id: params[:post][:tag_ids])
      if params[:comment].present? && params[:comment][:content].present?
        @comment = @post.comments.build(content: params[:comment][:content], user: current_user)
        if @comment.save
          if params[:rating].present? && params[:rating][:score].present?
            @rating = @comment.ratings.build(score: params[:rating][:score], user: current_user)
            @rating.save
          end
        end
      end
      
      redirect_to @post, notice: '投稿が作成されました'
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if params[:post][:tag_ids].blank?
      flash[:alert] = 'タグをすべて削除することはできません'
      render :edit
    else
      # 画像の削除
      if params[:post][:remove_image_ids].present?
        params[:post][:remove_image_ids].each do |image_id|
          image = @post.images.find_by(id: image_id)
          image.purge if image
        end
      end
      # 新しい画像の追加
      if params[:post][:images].present?
        @post.images.attach(params[:post][:images])
      end
      if @post.update(post_params_without_images)
        redirect_to @post, notice: '投稿が更新されました'
      else
        render :edit
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: '投稿が削除されました'
  end
  
  
  private
  
    # 設備のタイトルを設定するメソッド
  def facility_title(facility_type)
    case facility_type
    when 'nursing_room'
      '授乳室'
    when 'diaper_changing_station'
      'おむつ替え'
    else
      ''
    end
  end
  
  def ensure_not_guest_user
    if current_user.guest_user?
      redirect_to posts_path, alert: '投稿にはユーザー登録が必要です'
    end
  end
  
  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to post_path(@post), alert: '他のユーザーの投稿は編集できません'
    end
  end
  
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
  
  def post_params
    params.require(:post).permit(:title, :facility_type, :address, :latitude, :longitude, :postal_code, images: [], tag_ids: [])
  end
  
  def post_params_without_images
    params.require(:post).permit(:title, :facility_type, :address, :latitude, :longitude, :postal_code, tag_ids: [])
  end
end
