module Api
  module V1
    class VerificationController < Api::ApiController
      skip_before_action :authenticate_request, only: [:verify_otp, :resend_otp, :send_otp]
      before_action :set_user

      def send_otp
        if @user
          @user.generate_otp
          render json: { message: "OTP sent successfully" }, status: :ok
        else
          user_not_found
        end
      end

      def verify_otp
        if valid_otp?(@user, params[:otp])
          set_auth_header_for(@user)
          render json: { message: "OTP verified", user: @user }, status: :ok
        else
          render json: { error: 'Invalid OTP or OTP expired' }, status: :unprocessable_entity
        end
      end

      def resend_otp
        if @user
          @user.generate_otp
          render json: { message: "OTP resent successfully" }, status: :ok
        else
          user_not_found
        end
      end

      private

      def set_user
        @user = User.find_by(email: params[:email]&.downcase)
      end

      def valid_otp?(user, input_code)
        user.present? &&
          user.otp_code.present? &&
          user.otp_code == input_code &&
          user.otp_code_at.present? &&
          user.otp_code_at > 10.minutes.ago
      end

      def user_not_found
        render json: { error: "User not found" }, status: :not_found
      end
    end
  end
end
