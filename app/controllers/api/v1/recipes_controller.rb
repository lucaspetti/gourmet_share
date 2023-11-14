module Api
  module V1
    class RecipesController < ApplicationController
      # before_action :authorize_request, except: [:index, :show]

      def index
        @recipes = Recipe.all
        render json: @recipes
      end

      def create
        recipe = Recipe.new(recipe_params)
        if recipe.save
          render json: recipe
        else
          render json: { "error": "" }, status: :unprocessable_entity
        end
      end

      def show
        @recipe = Recipe.find(params[:id])
        render json: @recipe
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: "Not found" }, status: :not_found
      end

      def update; end

      # TODO: define if this will go to a new model RecipeUpload
      def bulk_upload; end

      def delete; end

      private

      def recipe_params
        # TODO: specify params here
        params.require(:recipe).permit!
      end
    end
  end
end
