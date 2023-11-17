module Api
  module V1
    class UsersController < ApplicationController
      before_action :doorkeeper_authorize!

      def show
        render json: current_user
      end
    end
  end
end
