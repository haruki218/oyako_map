class Public::RatingController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @rating = @post.ratings.build(rating_params)
    @rating.user = current_user
    if @rating.save
      redirect_to @post, notice: '評価が追加されました'
    else
      redirect_to @post, alert: '評価の追加に失敗しました'
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:score)
  end
end
