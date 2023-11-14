class RecipeCreatedJob < ApplicationJob
  queue_as :default

  def perform(recipe)
    ActionCable.server.broadcast 'recipes_channel', recipe.to_json
  end
end
