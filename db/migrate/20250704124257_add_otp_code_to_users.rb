class AddOtpCodeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :otp_code, :string
  end
end
