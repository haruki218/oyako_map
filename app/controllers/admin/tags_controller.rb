class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @tag = Tag.find(params[:id])
    @facility_type = params[:facility_type]
    @posts = @tag.posts
    # 施設タイプによる絞り込み
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

  def index
    @tags = Tag.all
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path, notice: 'タグが作成されました'
    else
      @tag = Tag.all
      render :index, alert: 'タグの作成に失敗しました'
    end
  end

def destroy
  @tag = Tag.find(params[:id])
  if @tag.posts.exists?
    redirect_to admin_tags_path, alert: 'このタグは既に投稿で使用されています。削除できません。'
  else
    @tag.destroy
    redirect_to admin_tags_path, notice: 'タグが削除されました'
  end
end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name)
  end
end
