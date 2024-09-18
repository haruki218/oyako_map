class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:facility_type].present?
      if params[:facility_type] == ""
        # すべて表示
        @posts = Post.order(created_at: :desc)
      else
        # 選択した投稿種別で絞り込み
        @posts = Post.where(facility_type: params[:facility_type]).order(created_at: :desc)
      end
    else
      @posts = Post.order(created_at: :desc)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @rating = Rating.new
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
