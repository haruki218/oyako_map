class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.order(created_at: :desc)
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
    @tag.destroy
    redirect_to admin_tags_path, notice: 'タグが削除されました'
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name)
  end
end
