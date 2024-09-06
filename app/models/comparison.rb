class Comparison < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :property_comparisons
  has_many :properties, through: :property_comparisons
  has_many :comments

  # Validations
  validates :price_difference, presence: true, numericality: true
  validates :size_difference, presence: true, numericality: true

  # We need to ensure that each comparison has exactly two properties
  validate :must_have_two_properties

  private

  def must_have_two_properties
    errors.add(:base, "Must compare exactly two properties") if properties.size != 2
  end
end
