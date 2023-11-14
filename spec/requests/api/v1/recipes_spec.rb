require 'rails_helper'

describe 'Api V1 recipes', type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }

  let(:recipe_response) do
    {
      id: recipe.id,
      title: recipe.title,
      description: recipe.description,
      ingredients: recipe.ingredients,
      preparation_steps: recipe.preparation_steps,
      created_at: recipe.created_at,
      author: recipe.user.email
    }
  end

  describe 'GET /api/v1/recipes' do
    before do
      allow(Recipe).to receive(:all).and_return([recipe])
      get '/api/v1/recipes'
    end

    it 'returns all created recipes in json format' do
      expect(response.status).to eq(200)
      expect(response.body).to eq([recipe_response].to_json)
    end
  end

  describe 'GET /api/v1/recipes/:id' do
    context 'when it is not found' do
      before do
        get "/api/v1/recipes/unknown"
      end

      it 'returns a 404 not found response' do
        expect(response.status).to eq(404)
        expect(response.body).to eq({ "error": "Not found" }.to_json)
      end
    end

    context 'when it is found' do
      before do
        allow(Recipe).to receive(:find).with(recipe.id).and_return(recipe)
        get "/api/v1/recipes/#{recipe.id}"
      end

      it 'returns the recipe in json format' do
        expect(response.status).to eq(200)
        expect(response.body).to eq(recipe_response.to_json)
      end
    end
  end
end
