class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  def generate_otp
    self.otp_code = rand(100000..999999).to_s
    self.otp_code_at = Time.current
    self.save!
    UserMailer.otp_send(self).deliver_later
  end
   

  def otp
    OpenStruct.new(
      code: otp_code,
      expired?: otp_code_at.nil? || otp_code_at < 10.minutes.ago
    )
  end 
end
