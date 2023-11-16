require 'rails_helper'

RSpec.describe RecipeFactory do
  let(:user) { create(:user) }
  let(:recipe_title) { 'Example title' }
  let(:recipe_description) { 'A great meal for two' }
  let(:recipe_params) do
    {
      title: recipe_title,
      description: recipe_description,
      ingredients: ['Salt', 'Pepper'],
      preparation_steps: ['Mix the salt with the pepper', 'Let it stir']
    }
  end

  describe '#save' do
    let(:recipe_factory) { described_class.new(user, recipe_params) }

    context 'when recipe already exists and params are valid' do
      let!(:recipe) { create(:recipe, title: recipe_title, user_id: user.id) }

      it 'updates the recipe' do
        recipe_factory.save
        expect(recipe.reload.description).to eq(recipe_description)
      end
    end

    context 'when recipe_params are invalid' do
      let(:recipe_params) { {} }

      it 'returns false' do
        expect(recipe_factory.save).to be_falsey
      end
    end

    context 'when recipe does not exist' do
      it 'saves the new record' do
        expect { recipe_factory.save }.to change(Recipe, :count).by(1)
      end
    end
  end
end
