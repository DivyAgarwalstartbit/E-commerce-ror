class UserMailer < ApplicationMailer
  default from: ENV['OUTLOOK_SMTP_USERNAME']

  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/users/sign_in' # or your production URL
    mail(to: @user.email, subject: 'Welcome to MyApp!')
  end
end
