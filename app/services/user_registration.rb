class UserRegistration
  attr_reader :status, :error_message

  def initialize(user)
    @user = user
  end

  def register(stripe_token, invitation_token)
    if @user.valid?
      charge = charge_card(stripe_token)

      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.send_welcome_email(@user).deliver
        @status = :success
      else
        @status = :failure
        @error_message = charge.error_message
      end
    else
      @status = :failure
      @error_message = 'Invalid user information. Please check the errors below'
    end

    self
  end

  def charge_card(stripe_token)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    StripeWrapper::Charge.create(
      :amount => 999,
      :card => stripe_token,
      :description => "Sign up charge for #{@user.email}"
    )
  end

  def successful?
    status == :success
  end
  
  private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end
