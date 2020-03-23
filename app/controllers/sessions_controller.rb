class SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(params[:email])

    if user && user.valid_password?(params[:password])
      @current_user = user
    else
      render json: { errors: 'Username/Password incorrect.' }, status: :unprocessable_entity
    end
  end
end