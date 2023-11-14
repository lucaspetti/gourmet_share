class Recipe < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  # TODO: validate_uniqueness_of title scoped by user_id
  # TODO: Add attached image

  def as_json(options = {})
    options[:except] = [:user_id, :updated_at]
    super(options).tap { |recipe| recipe['author'] = user.email }
  end
end
