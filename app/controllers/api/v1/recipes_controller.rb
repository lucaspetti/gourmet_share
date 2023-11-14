module Api
  module V1
    class RecipesController < ApplicationController
      before_action :authenticate_user, except: [:index, :show]
      before_action :set_recipe, only: [:show, :update, :destroy]

      def index
        @recipes = Recipe.all
        render json: @recipes
      end

      def create
        recipe = Recipe.new(recipe_params)
        recipe.user = current_user

        if recipe.save
          render json: recipe, status: :created
        else
          render json: { "error": "Could not create recipe" }, status: :unprocessable_entity
        end
      end

      def show
        render json: @recipe
      end

      # TODO: define if this will go to a new model RecipeUpload
      def bulk_upload; end

      private

      def set_recipe
        @recipe = Recipe.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: "Not found" }, status: :not_found
      end

      def recipe_params
        params.require(:recipe).permit(
          :title, :description, :ingredients, :preparation_steps, :image
        )
      end
    end
  end
end
