module Api
  class ApiController < ActionController::API
    before_action :authenticate_request

    private

    def authenticate_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header
  
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded
  
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    def set_auth_header_for(user)
      token = JsonWebToken.encode(user_id: user.id)
      response.set_header('Authorization', token)
    end
    
  end
end
