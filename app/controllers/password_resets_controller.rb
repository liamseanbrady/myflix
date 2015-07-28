class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = params[:id]
      render :show
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find_by(token: params[:token])
    if user
      user.password = params[:password]
      user.generate_token!
      user.save
      redirect_to sign_in_path, success: 'You have successfully reset your password'
    else
      redirect_to expired_token_path
    end
  end
end
