require 'rails_helper'

RSpec.describe RecipeUpload, type: :model do
  subject(:recipe_upload) { described_class.new(user: user) }
  let(:user) { create(:user) }

  it { is_expected.to have_db_column(:finished_at).of_type(:datetime) }

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'file validations' do
    context 'when no file is provided' do
      before { recipe_upload.valid? }

      it 'has error blank on file' do
        expect(recipe_upload.errors[:file]).to include("can't be blank")
      end
    end

    context 'when an invalid file is provided' do
      let(:filepath) { Rails.root.join('spec', 'fixtures', 'recipes', 'recipes.json') }
      let(:csv_file) { File.open(filepath) }

      before do
        recipe_upload.file.attach(io: csv_file, filename: 'recipes.json')

        recipe_upload.valid?
      end

      it 'has error invalid on file' do
        expect(recipe_upload.errors[:file]).to include("is invalid")
      end
    end

    context 'when a valid file is provided' do
      let(:filepath) { Rails.root.join('spec', 'fixtures', 'recipes', 'recipes.csv') }
      let(:csv_file) { File.open(filepath) }

      before do
        recipe_upload.file.attach(io: csv_file, filename: 'recipes.csv')
        recipe_upload.valid?
      end

      it 'has no errors' do
        expect(recipe_upload.errors).to be_empty
      end
    end
  end
end
