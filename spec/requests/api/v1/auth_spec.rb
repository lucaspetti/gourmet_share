require 'rails_helper'

describe 'Api V1 authentication', type: :request do
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let(:params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST /api/v1/auth/signup' do
    before do
      post '/api/v1/auth/signup', params: params
    end

    context 'when client is not found' do
      let(:params) do
        {
          client_id: 'not_found'
        }
      end

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({ "error": I18n.t('doorkeeper.errors.messages.invalid_client') }.to_json)
      end
    end

    context 'when client is found but user_params are invalid' do
      let(:params) do
        {
          client_id: client.uid,
          user: {
            email: 'new@user.com',
            password: '',
            first_name: 'Max',
            last_name: 'Mustermann'
          }
        }
      end

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(422)
        expect(response.body).to eq({ error: 'Registration failed' }.to_json)
      end
    end

    context 'when client is found and user_params are valid' do
      let(:user) { User.last }
      let(:access_token) { Doorkeeper::AccessToken.last }
      let(:params) do
        {
          client_id: client.uid,
          user: {
            email: 'new@user.com',
            password: 'S4f3P4ssw0rd!',
            first_name: 'Max',
            last_name: 'Mustermann'
          }
        }
      end
      let(:user_token_response) do
        {
          user: user,
          refresh_token: access_token.refresh_token,
          access_token: access_token.token
        }.to_json
      end

      it 'returns a successful response with user token' do
        expect(response.status).to eq(200)
        expect(response.body).to eq(user_token_response)
      end
    end
  end

  describe 'POST api/v1/login' do
    before do
      post '/api/v1/auth/login', params: params
    end

    context 'when user is not found' do
      let(:params) do
        { email: 'not_found@example.com' }
      end

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({ "error": I18n.t('doorkeeper.errors.messages.invalid_client') }.to_json)
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
        expect(response.body).to eq({ "error": I18n.t('doorkeeper.errors.messages.invalid_client') }.to_json)
      end
    end

    context 'when authentication is successful' do
      let(:access_token) { Doorkeeper::AccessToken.last }
      let(:params) do
        {
          client_id: client.uid,
          user: {
            email: user.email,
            password: user.password
          }
        }
      end
      let(:user_token_response) do
        {
          user: user,
          refresh_token: access_token.refresh_token,
          access_token: access_token.token
        }.to_json
      end

      it 'returns successful response with Bearer token' do
        expect(response.status).to eq(200)
        expect(response.body).to eq(user_token_response)
      end
    end
  end
end
