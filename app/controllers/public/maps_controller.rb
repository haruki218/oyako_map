class Public::MapsController < ApplicationController
  def show
    @prefecture = params[:prefecture_name]
    # 該当の都道府県に関連する投稿を取得
    @posts = Post.where("address LIKE ?", "%#{@prefecture}%")
    respond_to do |format|
      format.html
      format.json { render json: @posts.to_json(include: { tags: { only: :name } }, methods: :average_rating) }
    end
  end
end
