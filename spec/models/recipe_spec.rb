require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:ingredients).of_type(:text) }
    it { is_expected.to have_db_column(:preparation_steps).of_type(:text) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
  end
end
