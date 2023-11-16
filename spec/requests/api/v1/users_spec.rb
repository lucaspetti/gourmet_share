require 'rails_helper'

describe 'Api V1 users', type: :request do
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let(:token) { user_token(client, user) }
  let(:headers) do
    { 'Authorization': "Bearer #{token}" }
  end

  describe 'GET /api/v1/me' do
    before do
      get "/api/v1/me", headers: headers
    end

    context 'when user is not authenticated' do
      let(:token) { 'invalid' }

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'when response is successful' do
      it 'returns 200 and renders user data' do
        expect(response.status).to eq(200)
        expect(response.body).to eq(user.to_json)
      end
    end
  end
end
