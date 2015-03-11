class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: 'You are signed in. Enjoy!'
    else
      redirect_to sign_in_path, danger: 'Invalid email or password.'
    end
  end
end
