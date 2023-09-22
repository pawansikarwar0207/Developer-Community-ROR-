class UserMailer < ApplicationMailer
  def send_otp_email(user, otp_verification_url)
    @user = user
    @otp = user.otp
    @otp_verification_url = otp_verification_url
    mail(to: @user.email, subject: 'OTP Verification')
  end
end
