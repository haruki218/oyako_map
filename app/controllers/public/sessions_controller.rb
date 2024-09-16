class Public::SessionsController < Devise::SessionsController
  
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
  
end