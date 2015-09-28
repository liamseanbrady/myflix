class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    send_email('ingin@example.com', user.email, 'Welcome to MyFlix')
  end

  def send_reset_password_email(user)
    @user = user
    send_email('ingin@example.com', user.email, 'You can now reset your password')
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    send_email('ingin@example.com', invitation.recipient_email, invitation.message)
  end

  private 

  def send_email(sender, recipient, subject)
    if Rails.env.staging?
      mail from: sender, to: ENV[TEST_EMAIL], subject: subject
    else
      mail from: sender, to: recipient, subject: subject
    end
  end
end
