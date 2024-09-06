class PropertyComparison < ApplicationRecord
  belongs_to :property
  belongs_to :comparison

  validates :property_id, uniqueness: { scope: :comparison_id }
end
