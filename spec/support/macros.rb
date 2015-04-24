def set_current_user(a_user)
  user = a_user || Fabricate(:user)
  session[:user_id] = user.id
end
