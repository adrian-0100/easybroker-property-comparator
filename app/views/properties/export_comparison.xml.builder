xml.instruct!
xml.property_comparison do
  xml.property_1 do
    xml.title @property_1[:title]
    xml.price @property_1[:formatted_price]
    xml.size @property_1[:size]
  end
  xml.property_2 do
    xml.title @property_2[:title]
    xml.price @property_2[:formatted_price]
    xml.size @property_2[:size]
  end
  xml.comparison do
    xml.price_difference number_to_percentage(@price_difference, precision: 2)
    xml.size_difference number_to_percentage(@size_difference, precision: 2)
  end
end
