class PropertiesController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  def compare
    client = EasyBrokerClient.new

    @property_1 = client.get_property(params[:property_id_1])
    @property_2 = client.get_property(params[:property_id_2])

    if @property_1 && @property_2
      @price_difference = calculate_percentage_difference(extract_numeric_value(@property_1[:formatted_price]),
                                                          extract_numeric_value(@property_2[:formatted_price]))
      @size_difference = calculate_percentage_difference(extract_numeric_value(@property_1[:size]),
                                                         extract_numeric_value(@property_2[:size]))

      # Save consulted properties
      save_property(@property_1, params[:property_id_1])
      save_property(@property_2, params[:property_id_2])

      # Save comparison
      save_comparison(@property_1, @property_2, params[:property_id_1], params[:property_id_2])
    else
      flash[:error] = "No se pudieron obtener las propiedades."
      redirect_to root_path
    end
  end

  def export_comparison
    @property_1 = client.get_property(params[:property_id_1])
    @property_2 = client.get_property(params[:property_id_2])

    @price_difference = calculate_percentage_difference(extract_numeric_value(@property_1[:formatted_price]),
                                                        extract_numeric_value(@property_2[:formatted_price]))
    @size_difference = calculate_percentage_difference(extract_numeric_value(@property_1[:size]),
                                                       extract_numeric_value(@property_2[:size]))

    respond_to do |format|
      format.xml do
        response.headers["Content-Disposition"] = 'attachment; filename="property_comparison.xml"'
        render :export_comparison
      end
    end
  end

  private

  def save_property(property_data, easybroker_id)
    Property.find_or_create_by(easybroker_id: easybroker_id) do |property|
      property.title = property_data[:title]
      property.price = extract_numeric_value(property_data[:formatted_price])
      property.size = extract_numeric_value(property_data[:size])
    end
  end

  def save_comparison(property_1, property_2, id_1, id_2)
    prop1 = Property.find_by(easybroker_id: id_1)
    prop2 = Property.find_by(easybroker_id: id_2)

    if prop1 && prop2
      comparison = Comparison.new(
        price_difference: @price_difference,
        size_difference: @size_difference,
        user: current_user
      )

      if comparison.save
        comparison.properties << [ prop1, prop2 ]
        Rails.logger.debug "Comparison saved successfully: #{comparison.inspect}"
      else
        Rails.logger.debug "Failed to save comparison: #{comparison.errors.full_messages}"
      end
    else
      Rails.logger.debug "Failed to find properties for comparison: #{id_1}, #{id_2}"
    end
  end

  def client
    @client ||= EasyBrokerClient.new
  end

  def extract_numeric_value(string)
    string.gsub(/[^\d.]/, "").to_f
  end

  def calculate_percentage_difference(value1, value2)
    return 0.0 if value1 == 0.0 || value2 == 0.0
    ((value1 - value2).abs / [ (value1 + value2) / 2, 1 ].max) * 100
  end
end
