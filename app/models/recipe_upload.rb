class RecipeUpload < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user

  has_one_attached :file

  validates :user_id, presence: true
  validate :valid_file?

  private

  def valid_file?
    return errors.add(:file, :blank) unless file.attached?

    errors.add(:file, :invalid) unless file.content_type == 'text/csv'
  end
end
