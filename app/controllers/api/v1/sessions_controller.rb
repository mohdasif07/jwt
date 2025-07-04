module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :authenticate_request, only: [:sign_in, :sign_up]

      def sign_in
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          set_auth_header_for(user)
          render json: { user: user }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def sign_up
        if params[:user][:password] != params[:user][:password_confirmation]
          render json: { error: "Password and confirmation do not match" }, status: :unprocessable_entity
          return
        end
        
        user = User.new(user_params)
        if user.save
          render json: { message: "Sign Up seccessfully" }, status: :created
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end
  end
end
