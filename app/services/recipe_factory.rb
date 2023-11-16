class RecipeFactory
  attr_reader :recipe

  def initialize(user, recipe_params)
    @user = user
    @params = recipe_params
    @recipe = find_or_new_recipe
  end

  def self.create(user, recipe_params)
    new(user, recipe_params).save
  end

  def save
    save_recipe

    recipe
  rescue ActiveRecord::RecordInvalid => e
    # TODO: error could be logged here
  end

  private

  def save_recipe
    recipe.new_record? ? create_recipe : update_recipe
  end

  def create_recipe
    recipe.ingredients = parse_ingredients
    recipe.preparation_steps = parse_preparation_steps
    recipe.user = @user
    recipe.save!
  end

  def update_recipe
    recipe.update(@params)
  end

  def find_or_new_recipe
    Recipe.find_by(user_id: @user.id, title: @params[:title]) || Recipe.new(@params)
  end

  def parse_ingredients
    @params[:ingredients]&.split(';')
  end

  def parse_preparation_steps
    @params[:preparation_steps]&.split(';')
  end
end
