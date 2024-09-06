class Property < ApplicationRecord
  # Associations
  has_many :property_comparisons
  has_many :comparisons, through: :property_comparisons

  # Validations
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :size, presence: true, numericality: { greater_than: 0 }
  validates :easybroker_id, presence: true, uniqueness: true

  # Callbacks
  before_save :format_price

  private

  def format_price
    self.formatted_price = "$#{price.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
  end
end
