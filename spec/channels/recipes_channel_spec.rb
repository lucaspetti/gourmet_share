require 'rails_helper'

RSpec.describe RecipesChannel, type: :channel do
  let(:user) { create(:user) }

  context 'when user connecting is registered' do
    before do
      stub_connection(current_user: user)
      subscribe(user_id: user.id)
    end

    it { expect(subscription).to be_confirmed }

    it do
      channel = 'recipes_channel'
      expect(subscription).to have_stream_from(channel)
    end
  end

  context 'when user connecting is not registered' do
    before do
      stub_connection(current_user: user)
      subscribe(user_id: 'unknown')
    end

    it { expect(subscription).to be_rejected }
  end
end
