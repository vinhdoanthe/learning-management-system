class UserMailer < ApplicationMailer
  default from: 'vinhdt@teky.edu.vn'

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
