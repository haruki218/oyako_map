class Public::PostsController < ApplicationController
  
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
    @posts = Post.all
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
      
      redirect_to @post, notice: '投稿が作成されました。'
    else
      render :new_play
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    # 設備の更新時にfacility_typeを設定
    if params[:facility_type].present?
      @post.facility_type = params[:facility_type]
      @post.title = facility_title(params[:facility_type])
    end
    if @post.update(post_params)
      redirect_to @post, notice: '投稿が更新されました。'
    else
      render :edit
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
  
  def post_params
    params.require(:post).permit(:title, :address, :image, :facility_type, tag_ids: [])
  end
end
