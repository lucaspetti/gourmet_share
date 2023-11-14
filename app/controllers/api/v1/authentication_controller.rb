module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        user = User.find_by_email(login_params[:email])

        if user&.valid_password?(login_params[:password])
          token = JwtWrapper.encode(user_id: user.id)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
