require 'rails_helper'

RSpec.describe Recipe, type: :model do
  subject(:recipe) { create :recipe }

  describe 'columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:ingredients).of_type(:text) }
    it { is_expected.to have_db_column(:preparation_steps).of_type(:text) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:user_id) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'image_url' do
    context 'when there is no image attached' do
      it 'returns nil' do
        expect(recipe.image_url).to be_nil
      end
    end

    context 'when there is an image attached' do
      let(:filepath) { Rails.root.join('spec', 'fixtures', 'images', 'spaghetti.jpeg') }
      let(:image_file) { File.open(filepath) }

      it 'returns the correct image_url' do
        recipe.image.attach(io: image_file, filename: 'spaghetti.jpeg')
        expect(recipe.image_url).to include('http://testhost.com/rails/active_storage/blobs')
      end
    end
  end
end
