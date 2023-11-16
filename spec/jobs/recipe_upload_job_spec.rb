require 'rails_helper'

RSpec.describe RecipeUploadJob, type: :job do
  let(:recipe_upload) { instance_double(RecipeUpload, user_id: 'mock_id') }
  let(:mock_file) { instance_double(File) }
  let(:mock_recipe_upload_id) { 'upload_id' }
  let(:perform) { described_class.new.perform(mock_recipe_upload_id) }

  describe 'perform' do
    before do
      allow(RecipeUpload).to receive(:find).with(mock_recipe_upload_id).and_return(recipe_upload)
      allow(recipe_upload).to receive_message_chain(:file, :download).and_return(mock_file)
      allow(RecipeUploadService).to receive(:run).with(recipe_upload.user_id, mock_file)
      allow(recipe_upload).to receive(:update!)
      perform
    end

    it 'calls recipe upload service and sets recipe_upload finished_at field' do
      expect(recipe_upload).to have_received(:update!).once
    end
  end
end
