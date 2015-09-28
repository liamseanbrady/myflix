class AppMailer < ActionMailer::Base
  default from: 'no-reply@myflix.com'

  def send_welcome_email(user)
    @user = user
    send_mail to: user.email, subject: 'Welcome to MyFlix'
  end

  def send_reset_password_email(user)
    @user = user
    send_mail to: user.email, subject: 'You can now reset your password'
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    send_mail to: invitation.recipient_email, subject: invitation.message
  end

  private

  def send_mail(to: recipient, subject: subject)
    if Rails.env.staging?
      mail to: ENV[TEST_EMAIL], subject: subject
    else
      mail to: recipient, subject: subject
    end
  end
end
