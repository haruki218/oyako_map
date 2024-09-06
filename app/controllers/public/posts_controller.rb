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
    if @post.update(post_params)
      @post.tags = Tag.where(id: params[:post][:tag_ids])
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
  
  def post_params
    params.require(:post).permit(:title, :address, tag_ids: [])
  end
  
  
end
