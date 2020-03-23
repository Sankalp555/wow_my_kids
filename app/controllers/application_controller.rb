class ApplicationController < ActionController::Base

  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :authenticate_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :gender])
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      token = request.headers['Authorization']
      begin
        jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

  def authenticate_user!(options = {})
    unless params[:controller] == "sessions" || params[:action] == 'create'
      head :unauthorized unless signed_in?
    end
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

end
