class Public::CommentController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @post, notice: 'コメントが追加されました。'
    else
      redirect_to @post, alert: 'コメントの追加に失敗しました。'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(params[:post_id]), notice: 'コメントが削除されました。'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
