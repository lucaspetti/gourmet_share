require 'rails_helper'

RSpec.describe RecipeCreatedJob, type: :job do
  let(:recipe_json) { { id: 'mock_id', title: 'mock_title' }.to_json }
  let(:recipe) { instance_double(Recipe, to_json: recipe_json) }

  describe 'perform' do
    let(:action_cable_server_mock) { instance_double(ActionCable::Server::Base) }

    before do
      allow(ActionCable).to receive(:server).and_return(action_cable_server_mock)
      allow(action_cable_server_mock).to receive(:broadcast)
      described_class.perform_now(recipe)
    end

    it 'calls action cable to notify subscribed users' do
      expect(action_cable_server_mock).to have_received(:broadcast).with(
        'recipes_channel', recipe_json
      )
    end
  end
end
