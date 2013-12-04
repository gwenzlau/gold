class ApplicationController < ActionController::Base
  protect_from_forgery
  

  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:signature, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:signature, :email, :password, :password_confirmation, :remember_me, :current_password)
      end
    end
end
