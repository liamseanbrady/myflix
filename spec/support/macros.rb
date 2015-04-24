def set_current_user(user = Fabricate(:user))
  session[:user_id] = user.id
end
