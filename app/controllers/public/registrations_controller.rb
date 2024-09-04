class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params
  
  def after_sign_up_path_for(resource)
    main_page_path
  end
  
  # サインアップ失敗時に新規登録ページを再表示
  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      flash[:alert] = resource.errors.full_messages.join(', ')
      redirect_to new_user_registration_path
    end
  end
  
  protected
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
