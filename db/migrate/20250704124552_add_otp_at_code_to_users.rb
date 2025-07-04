class AddOtpAtCodeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :otp_code_at, :datetime
  end
end
