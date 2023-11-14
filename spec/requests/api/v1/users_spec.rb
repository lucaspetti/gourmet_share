require 'rails_helper'

describe 'Api V1 users', type: :request do
  let(:user) { create(:user) }
  let(:token) { user_token(user) }
  let(:headers) do
    { 'Authorization': "Bearer #{token}" }
  end

  describe 'GET /api/v1/users/:id' do
    before do
      get "/api/v1/users/#{user_id}", headers: headers
    end

    context 'when user is not authenticated' do
      let(:token) { 'invalid' }
      let(:user_id) { user.id }

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({error: 'Unauthorized'}.to_json)
      end
    end

    context 'when user is not found' do
      let(:user_id) { 'unknown' }

      it 'returns 404 not found' do
        expect(response.status).to eq(404)
        expect(response.body).to eq({error: 'User not found'}.to_json)
      end
    end

    context 'when user tries to see data for another user' do
      let(:user2) { create :user }
      let(:user_id) { user2.id }

      it 'returns 404 forbidden' do
        expect(response.status).to eq(404)
        expect(response.body).to eq({error: 'User not found'}.to_json)
      end
    end

    context 'when response is successful' do
      let(:user_id) { user.id }

      it 'returns 200 and renders user data' do
        expect(response.status).to eq(200)
        expect(response.body).to eq(user.to_json)
      end
    end
  end

  describe 'POST /api/v1/users' do
    before do
      post "/api/v1/users", params: params
    end

    context 'when it is successful' do
      let(:params) do
        {
          first_name: 'Max',
          last_name: 'Mustermann',
          email: 'max@mustermann.com',
          password: 'S4f3P4ssword!'
        }
      end

      it 'returns 200 and renders user data' do
        expect(response.status).to eq(201)
        expect(response.body).to eq(User.last.to_json)
      end
    end

    context 'when there is an error saving the user' do
      let(:params) do
        {}
      end

      it 'returns 422 error' do
        expect(response.status).to eq(422)
        expect(response.body).to eq({error: 'Could not create user'}.to_json)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    before do
      delete "/api/v1/users/#{user_id}", headers: headers
    end

    context 'when user is not authenticated' do
      let(:token) { 'invalid' }
      let(:user_id) { user.id }

      it 'returns 401 unauthorized' do
        expect(response.status).to eq(401)
        expect(response.body).to eq({error: 'Unauthorized'}.to_json)
      end
    end

    context 'when user is not found' do
      let(:user_id) { 'unknown' }

      it 'returns 404 not found' do
        expect(response.status).to eq(404)
        expect(response.body).to eq({error: 'User not found'}.to_json)
      end
    end

    context 'when user tries to see data for another user' do
      let(:user2) { create :user }
      let(:user_id) { user2.id }

      it 'returns 404 forbidden' do
        expect(response.status).to eq(404)
        expect(response.body).to eq({error: 'User not found'}.to_json)
      end
    end

    context 'when response is successful' do
      let(:user_id) { user.id }

      it 'returns 204 and deletes user record' do
        expect(response.status).to eq(204)
        expect(User.exists?(user_id)).to be false
      end
    end
  end
end
