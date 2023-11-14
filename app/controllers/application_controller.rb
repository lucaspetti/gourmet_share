class ApplicationController < ActionController::API
  def current_user
    @current_user ||= authenticate_user
  end

  private

  def authenticate_user
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header

    begin
      user_id = JwtWrapper.decode(token).dig(:user_id)
      User.find(user_id)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Unauthorized' }, status: :unauthorized
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
      # TODO: Error could be logged here
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
