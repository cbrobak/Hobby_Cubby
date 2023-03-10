class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :phone_number, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :phone_number, :first_name, :last_name])
  end
end
