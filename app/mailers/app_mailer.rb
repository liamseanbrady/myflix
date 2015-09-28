class AppMailer < ActionMailer::Base
  default from: 'no-reply@myflix.com'

  def send_welcome_email(user)
    @user = user
    send_mail user.email, 'Welcome to MyFlix'
  end

  def send_reset_password_email(user)
    @user = user
    send_mail user.email, 'You can now reset your password'
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    send_mail invitation.recipient_email, invitation.message
  end

  private

  def send_mail(recipient, subject)
    if Rails.env.staging?
      mail to: ENV['TEST_EMAIL'], subject: subject
    else
      mail to: recipient, subject: subject
    end
  end
end
