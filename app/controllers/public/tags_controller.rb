class Public::TagsController < ApplicationController
  
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
  
  def create
    @tag = Tag.find_or_create_by(name: params[:name])
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
  end
end
