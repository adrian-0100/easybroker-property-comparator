class User < ApplicationRecord
  # Associations
  has_many :comparisons
  has_many :comments

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }

  # If you decide to add authentication, you might include:
  # has_secure_password
  # validates :password, presence: true, length: { minimum: 6 }
end
