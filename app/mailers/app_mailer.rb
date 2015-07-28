class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: 'ingin@example.com', to: user.email, subject: 'Welcome to MyFlix'
  end

  def send_reset_password_email(user)
    @user = user
    mail from: 'ingin@example.com', to: user.email, subject: 'You can now reset your password'
  end
end
