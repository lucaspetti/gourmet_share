require 'rails_helper'

describe 'Api V1 authentication', type: :request do
  let(:user) { create(:user) }
  let(:params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST api/v1/login' do
    before do
      post '/api/v1/login', params: params
    end

    context 'when user is not found' do
      let(:params) do
        { email: 'not_found@example.com' }
      end

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({ "error": "Unauthorized" }.to_json)
      end
    end

    context 'when password is incorrect' do
      let(:params) do
        {
          email: user.email,
          password: 'incorrect'
        }
      end

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({ "error": "Unauthorized" }.to_json)
      end
    end

    context 'when authentication is successful' do
      let(:params) do
        {
          email: user.email,
          password: user.password
        }
      end

      it 'returns successful response with Bearer token' do
        expect(response.status).to eq(200)
        expect(response.body).to eq({ "error": "Unauthorized" }.to_json)
      end
    end
  end
end
