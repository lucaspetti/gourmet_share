require 'rails_helper'

describe 'Api V1 recipes', type: :request do
  let(:recipe) { create(:recipe) }
  let(:client) { create(:client) }
  let(:user) { create(:user) }
  let(:access_token) { user_token(client, user) }
  let(:token) { access_token.token }
  let(:headers) do
    { 'Authorization' => "Bearer #{token}" }
  end

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
    context 'when user is unauthorized' do
      let(:token) { 'invalid_token' }

      before do
        get '/api/v1/recipes'
      end

      it 'returns a 401 response' do
        expect(response.status).to eq(401)
      end
    end

    context 'when user is authorized' do
      before do
        allow(Recipe).to receive(:all).and_return([recipe])
        get '/api/v1/recipes', headers: headers
      end

      it 'returns all created recipes in json format' do
        expect(response.status).to eq(200)
        expect(response.body).to eq([recipe_response].to_json)
      end
    end
  end

  describe 'POST /api/v1/recipes' do
    context 'when user is unauthorized' do
      let(:token) { 'invalid_token' }

      before do
        post '/api/v1/recipes', headers: headers
      end

      it 'returns a 401 response' do
        expect(response.status).to eq(401)
      end
    end

    context 'when it is successful' do
      before do
        post '/api/v1/recipes', params: params, headers: headers
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
        expect(response.status).to eq(201)
        expect(response.body).to eq(Recipe.last.to_json)
      end
    end

    context 'when there is an error saving the recipe' do
      before do
        post '/api/v1/recipes', params: params, headers: headers
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
        get "/api/v1/recipes/unknown", headers: headers
      end

      it 'returns a 404 not found response' do
        expect(response.status).to eq(404)
        expect(response.body).to eq({ "error": "Not found" }.to_json)
      end
    end

    context 'when it is found' do
      before do
        allow(Recipe).to receive(:find).with(recipe.id).and_return(recipe)
        get "/api/v1/recipes/#{recipe.id}", headers: headers
      end

      it 'returns the recipe in json format' do
        expect(response.status).to eq(200)
        expect(response.body).to eq(recipe_response.to_json)
      end
    end
  end
end
