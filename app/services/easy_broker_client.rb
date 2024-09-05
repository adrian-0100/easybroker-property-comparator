require 'httparty'

class EasyBrokerClient
  include HTTParty
  base_uri 'https://api.stagingeb.com/v1'

  def initialize
    @api_key = ENV['EASYBROKER_API_KEY']
  end

  def get_property(property_id)
    options = { headers: { "X-Authorization" => @api_key } }
    response = self.class.get("/properties/#{property_id}", options)
    
    if response.success?
      property_data = response.parsed_response
      {
        title: property_data['title'],
        formatted_price: extract_price(property_data),
        size: format_size(property_data['construction_size'])
      }
    else
      raise "Error obteniendo propiedad: #{response.code}"
    end
  end

  private

  def extract_price(property_data)
    sale_operation = property_data['operations']&.find { |op| op['type'] == 'sale' }
    if sale_operation && sale_operation['amount']
      "#{sale_operation['formated_amount']} (#{sale_operation['amount']} #{sale_operation['currency']})"
    else
      'N/A'
    end
  end

  def format_size(size)
    size.nil? ? 'N/A' : "#{size} m²"
  end
end