class Public::PostsController < ApplicationController
  
  def new
  end

  def new_play
    @post = Post.new
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
      
      @rating = @post.ratings.build(rating_params)
      @rating.user = current_user
      @rating.save
      
      if params[:comment_content].present?
        @comment = @post.comments.build(content: params[:comment_content])
        @comment.user = current_user
        @comment.save
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
  
  def rating_params
    params.require(:rating).permit(:score)
  end
  
end
