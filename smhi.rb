module SMHI
  OneForecast = Struct.new :time, :celsius, :symbol do
    def day_or_night
      time.day_or_night?
    end
  end

  def weather_url lat, lon
    "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/#{lon}/lat/#{lat}/data.json"
  end

  def parse_raw_into_forecasts smhi_data, count
    time_series = smhi_data['timeSeries']
    all_forecasts = time_series.map do |one_point_in_time|
      params = one_point_in_time['parameters']
      forecast = OneForecast.new
      forecast.time = DateTime.parse( one_point_in_time['validTime'] )
      forecast.celsius = find_value 't', params
      forecast.symbol = find_value 'Wsymb2', params
      forecast
    end

    future_forecasts = all_forecasts.select { |forecast| forecast.time.is_future? }
    future_forecasts[0..count]
  end

  def find_value name, params
    the_one = params.detect { |p| p['name'] == name }
    the_one['values'].first
  end

  def hourly_forecasts lat, lon, count=20
    response = RestClient.get weather_url(lat, lon)
    the_data = JSON.parse response
    parse_raw_into_forecasts the_data, count
  end
end


