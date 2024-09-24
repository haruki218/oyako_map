class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]
  
  def after_sign_in_path_for(resource)
    main_page_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  
  # ゲストログイン
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to main_page_path, notice: 'ゲストユーザーとしてログインしました'
  end
  
  # 退会ユーザーを拒否
  def user_state
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    return unless user.valid_password?(params[:user][:password])
    if user.is_active == false
      flash[:alert] = "このアカウントは停止されています。"
      redirect_to new_user_session_path
    end
  end
  
end