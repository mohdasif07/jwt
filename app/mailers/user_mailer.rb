class UserMailer < ApplicationMailer
  default from: 'chetanshendge78901@gmail.com'

  def otp_send(user)
    @user = user
    @otp = user.otp_code
    mail(to: @user.email, subject: "Your OTP Code")
  end

end
