json.(@current_user, :id, :email, :first_name, :last_name, :phone_number, :gender)
json.token @current_user.generate_jwt