class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_guest_user, only: [:new, :new_play, :new_facility, :create, :edit, :update, :destroy]
  
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
    @posts = Post.order(created_at: :desc) # 新しい順に並べる
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @rating = Rating.new
  end

  def create
    @post = current_user.posts.build(post_params)
    # 設備の投稿時にfacility_typeを設定
    if params[:facility_type].present?
      @post.facility_type = params[:facility_type]
      @post.title = facility_title(params[:facility_type])
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
      render :new_play
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    # タグが１つも選択されていない場合
    if params[:post][:tag_ids].blank?
      flash[:alert] = 'タグをすべて削除することはできません'
      render :edit
    else
      if @post.update(post_params)
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
  
  def post_params
    params.require(:post).permit(:title, :image, :facility_type, :address, :latitude, :longitude, :postal_code, tag_ids: [])
  end
end
