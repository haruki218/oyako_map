class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
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

  def new
  end

  def create
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
      if @post.update(post_params)
        redirect_to admin_post_path(@post), notice: '投稿が更新されました'
      else
        render :edit
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_root_path, notice: '投稿が削除されました'
  end
  
  
  private
  
  def post_params
    params.require(:post).permit(:title, :image, :facility_type, :address, :latitude, :longitude, :postal_code, tag_ids: [])
  end
end
