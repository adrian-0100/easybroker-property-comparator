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
    else
      flash[:error] = "No se pudieron obtener las propiedades."
      redirect_to root_path
    end
  end

  def save_comparison
    comparison = Comparison.new(
      price_difference: params[:price_difference],
      size_difference: params[:size_difference],
      user: current_user
    )

    property1 = Property.find_by(easybroker_id: params[:property_id_1])
    property2 = Property.find_by(easybroker_id: params[:property_id_2])

    if property1 && property2
      comparison.properties = [ property1, property2 ]

      if comparison.save
        Comment.create(
          content: params[:comment],
          user: current_user,
          comparison: comparison
        )
        flash[:success] = "Comparison saved successfully with comment."
      else
        flash[:error] = "Error saving comparison: #{comparison.errors.full_messages.join(', ')}"
      end
    else
      flash[:error] = "Error: One or both properties not found."
    end

    redirect_to compare_properties_path(property_id_1: params[:property_id_1], property_id_2: params[:property_id_2])
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
