class UserMailer < ApplicationMailer
  default from: 'lms@teky.edu.vn'

  def password_reset(user)
    @user = user
    mail to: user.email_address_for_sending, subject: "Password reset"
  end
end
