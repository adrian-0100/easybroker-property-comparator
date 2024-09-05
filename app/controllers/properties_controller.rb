class PropertiesController < ApplicationController
    def compare
      client = EasyBrokerClient.new
  
      @property_1 = client.get_property(params[:property_id_1])
      @property_2 = client.get_property(params[:property_id_2])
  
      if @property_1 && @property_2
        @price_difference = calculate_percentage_difference(extract_numeric_value(@property_1[:formatted_price]), 
                                                            extract_numeric_value(@property_2[:formatted_price]))
        @size_difference = calculate_percentage_difference(extract_numeric_value(@property_1[:size]), 
                                                           extract_numeric_value(@property_2[:size]))
      else
        flash[:error] = "No se pudieron obtener las propiedades."
        redirect_to root_path
      end
    end
  
    private
  
    def extract_numeric_value(string)
      string.gsub(/[^\d.]/, '').to_f
    end
  
    def calculate_percentage_difference(value1, value2)
      return 0.0 if value1 == 0.0 || value2 == 0.0
      ((value1 - value2).abs / [(value1 + value2) / 2, 1].max) * 100
    end
  end