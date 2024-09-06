class Comment < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :comparison

  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
end
