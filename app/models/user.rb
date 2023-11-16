class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
         class_name: 'Doorkeeper::AccessGrant',
         foreign_key: :resource_owner_id,
         dependent: :delete_all

  has_many :access_tokens,
         class_name: 'Doorkeeper::AccessToken',
         foreign_key: :resource_owner_id,
         dependent: :delete_all

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
