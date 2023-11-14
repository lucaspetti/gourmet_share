class Recipe < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user

  has_one_attached :image

  validates :title, presence: true
  validates :description, presence: true
  validates_uniqueness_of :title, scope: :user_id
  validate :validate_image_type

  # TODO: after_create :notify_users

  def validate_image_type
    if image.attached? && !image.content_type.in?(%w(image/jpeg image/png))
      errors.add(:image, 'Must be a JPG or a PNG file')
    end
  end

  def as_json(options = {})
    options[:except] = [:user_id, :updated_at]
    super(options).tap do |recipe|
      recipe['author'] = user.email
      recipe['image_url'] = image_url
    end
  end

  def image_url
    url_for(image) if image.attached?
  end
end
