module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user, except: :create
      before_action :find_user, except: :create
      before_action :authorize_request, except: :create

      def show
        render json: @user
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: { "error": "Could not create user" },
                status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
      end

      private

      def find_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end

      def user_params
        params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end

      def authorize_request
        # Return not_found to avoid security issues
        if current_user.id != @user.id
          render json: { error: 'User not found' }, status: :not_found
        end
      end
    end
  end
end
