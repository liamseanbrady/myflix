class UserRegistration
  attr_reader :status, :error_message

  def initialize(user)
    @user = user
  end

  def register(stripe_token, invitation_token)
    if @user.valid?
      customer = set_up_customer(@user, stripe_token)

      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        handle_invitation(invitation_token)
        AppMailer.send_welcome_email(@user).deliver
        @status = :success
      else
        @status = :failure
        @error_message = customer.error_message
      end
    else
      @status = :failure
      @error_message = 'Invalid user information. Please check the errors below'
    end

    self
  end

  def set_up_customer(user, stripe_token)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    StripeWrapper::Customer.create(
      :card => stripe_token,
      :user => user,
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
