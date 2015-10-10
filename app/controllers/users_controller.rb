class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path and return if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )

      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.send_welcome_email(@user).deliver
        redirect_to sign_in_path
      else
        flash.now[:danger] = charge.error_message
        render :new
      end
    else
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

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end
