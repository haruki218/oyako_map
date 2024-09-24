class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
    @comments = @user.comments.order(created_at: :desc).page(params[:page]).per(5)
  end

  def update
    @user = User.find(params[:id])
    @user.update(is_active: !@user.is_active)
    redirect_to admin_users_path, notice: 'ステータスが変更されました。'
  end

  def delete_all_posts
    user = User.find(params[:id])
    user.posts.destroy_all
    redirect_to admin_user_path(user), notice: 'ユーザーの投稿をすべて削除しました。'
  end
  
  def delete_all_comments
    user = User.find(params[:id])
    user.comments.destroy_all
    redirect_to admin_user_path(user), notice: 'ユーザーのコメントをすべて削除しました。'
  end
end
