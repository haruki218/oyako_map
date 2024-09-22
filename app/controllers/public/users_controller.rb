class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:mypage, :edit, :posts, :update, :destroy]
  
  def mypage
    @post = current_user.posts.last
    @comment = current_user.comments.last
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(5)
  end
  
  def posts
    @posts = current_user.posts
  end
  
  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: "ユーザー情報が更新されました"
    else
      render :edit
    end
  end

  def destroy
    current_user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: "退会処理が完了しました"
  end
  
  private
  
  def ensure_guest_user
    @user = current_user
    if @user.guest_user?
      redirect_to main_page_path, alert: "ゲストユーザーはプロフィール画面へ遷移できません"
    end
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
