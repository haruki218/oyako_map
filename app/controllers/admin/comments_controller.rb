class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to admin_post_path(@post), notice:'コメントが削除されました'
  end
end
