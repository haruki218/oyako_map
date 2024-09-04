class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:mypage, :edit]
  
  def mypage
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
  
  private
  
  def ensure_guest_user
    @user = current_user
    if @user.guest_user?
      redirect_to main_page_path, alert: "ゲストユーザーはプロフィール画面へ遷移できません。"
    end
  end 
end
