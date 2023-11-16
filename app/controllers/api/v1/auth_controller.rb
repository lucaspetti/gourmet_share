module Api
  module V1
    class AuthController < ApplicationController
      before_action :fetch_client_app

      def signup
        @user = User.new(user_params)

        if @user.save
          return_user_token
        else
          return render json: { error: 'Registration failed' }, status: :unprocessable_entity
        end
      end

      def login
        @user = User.authenticate!(user_params[:email], user_params[:password])

        if @user
          return_user_token
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      private

      def fetch_client_app
        @client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
        render_unauthorized unless @client_app
      end

      def render_unauthorized
        return render json: { error: I18n.t('doorkeeper.errors.messages.invalid_client') },
                        status: :unauthorized
      end

      def return_user_token
        access_token = Doorkeeper::AccessToken.find_or_create_for(
          resource_owner: @user.id,
          application: @client_app,
          refresh_token: generate_refresh_token,
          expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
          scopes: 'read,write'
        )

        render json: { user: @user, refresh_token: access_token.refresh_token, access_token: access_token.token }
      end

      def generate_refresh_token
        SecureRandom.hex(32)
      end

      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
      end
    end
  end
end
