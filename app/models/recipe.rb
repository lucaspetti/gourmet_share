class Recipe < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  has_one_attached :image

  # TODO: validate_uniqueness_of title scoped by user_id

  def as_json(options = {})
    options[:except] = [:user_id, :updated_at]
    super(options).tap { |recipe| recipe['author'] = user.email }
  end
end
