class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy]
  before_action :ensure_not_guest_user, only: [:create, :destroy]
  
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      if params[:rating][:score].present?
        @rating = @comment.ratings.build(score: params[:rating][:score])
        @rating.user = current_user
        @rating.save
      end

      redirect_to @post, notice: 'コメントが追加されました'
    else
      redirect_to @post, alert: 'コメントの追加に失敗しました'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post), notice: 'コメントが削除されました'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def ensure_not_guest_user
    if current_user.guest_user?
      redirect_to @post, alert: 'コメントにはユーザー登録が必要です'
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
