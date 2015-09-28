class AppMailer < ActionMailer::Base
  default from: 'no-reply@myflix.com'

  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: 'Welcome to MyFlix'
  end

  def send_reset_password_email(user)
    @user = user
    mail to: user.email, 'You can now reset your password'
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: invitation.message
  end
end
