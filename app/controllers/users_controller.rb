class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path and return if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    result = UserRegistration.new(@user).register(params[:stripeToken], params[:invitation_token])

    if result.successful?
      flash[:success] = 'Thank you for registering with MyFlix. Please sign in now'
      redirect_to sign_in_path
    else
      flash[:danger] = result.error_message
      render :new
    end
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email) if invitation
      @invitation_token = params[:token]
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end
