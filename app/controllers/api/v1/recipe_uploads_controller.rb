module Api
  module V1
    class RecipeUploadsController < ApplicationController
      before_action :authenticate_user

      def create
        recipe_upload = RecipeUpload.new(recipe_upload_params)
        recipe_upload.user = current_user

        if recipe_upload.save
          RecipeUploadJob.perform_later(recipe_upload.id) if recipe_upload.persisted?
          render json: recipe_upload, status: :created
        else
          render json: { "error": "Could not create recipe upload" }, status: :unprocessable_entity
        end
      end

      private

      def recipe_upload_params
        params.require(:recipe_upload).permit(:file)
      end
    end
  end
end
