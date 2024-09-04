class Public::SessionsController < Devise::SessionsController
  
  def after_sign_in_path_for(resource)
    main_page_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  
end