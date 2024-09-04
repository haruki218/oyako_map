class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params
  
  def after_sign_up_path_for(resource)
    main_page_path
  end

  protected
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
