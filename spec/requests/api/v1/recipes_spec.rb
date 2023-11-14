require 'rails_helper'

describe 'Api V1 recipes', type: :request do
  let(:recipe) { create(:recipe) }
  let(:token) { user_token(user) }

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

  describe 'POST /api/v1/recipes' do
    let!(:user) { create(:user) }

    context 'when user is unauthorized' do
      let(:token) { 'invalid_token' }

      before do
        post '/api/v1/recipes', headers: { 'Authorization' => token }
      end

      it 'returns a 401 response' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({ "error": "Unauthorized" }.to_json)
      end
    end

    context 'when user is not found' do
      before do
        allow(User).to receive(:find).with(user.id).and_raise(ActiveRecord::RecordNotFound)
        post '/api/v1/recipes', headers: { 'Authorization' => token }
      end

      it 'returns a 401 response' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({ "error": "Unauthorized" }.to_json)
      end
    end

    context 'when it is successful' do
      before do
        post '/api/v1/recipes', params: params, headers: { 'Authorization' => token }
      end

      let(:params) do
        {
          recipe: {
            title: 'Spaghetti',
            description: 'A nice dish',
            ingredients: [],
            preparation_steps: []
          }
        }
      end

      it 'returns a successful response' do
        expect(response.status).to eq(200)
        expect(response.body).to eq(Recipe.first.to_json)
      end
    end

    context 'when there is an error saving the recipe' do
      before do
        post '/api/v1/recipes', params: params, headers: { 'Authorization' => token }
      end

      let(:params) do
        {
          recipe: {
            title: 'Spaghetti'
          }
        }
      end

      it 'returns a 422 response' do
        expect(response.status).to eq(422)
        expect(response.body).to eq({ "error": "Could not create recipe" }.to_json)
      end
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
