# coding: utf-8

LAT = '59.29'
LON = '18.11'
ZONE = 'Europe/Stockholm'

module SunMachine
  def sunrise date = Date.today
    sun_machine(date).compute_official_sunrise ZONE
  end

  def sunset date = Date.today
    sun_machine(date).compute_official_sunset ZONE
  end

  def sun_machine date
    SolarEventCalculator.new date, BigDecimal(LAT), BigDecimal(LON)
  end
end

class DateTime
  include SunMachine
  
  def is_future?
    self > DateTime.now
  end

  def in_stockholm
    sthlm_zone.to_local self
  end

  def sthlm_zone
    sthlm_zone = TZInfo::Timezone.get ZONE
  end

  def sun_is_up?
    self > sunrise(self.to_date) and self < sunset(self.to_date)
  end

  def day_or_night?
    sun_is_up? ? :day : :night
  end

  def viewable_time_of_day
    in_stockholm.strftime '%k:%M'
  end
end

module CommuteInformation
  def present_stop_information stop_description
    stop_id, stop_type = stop_description.split ':'
    stop_type ||= 'bus'

    # this endpoint was found by inspecting SLs travel planner
    response = RestClient.get "https://webcloud.sl.se/api/departures?mode=departures&origId=#{stop_id}"
    departures = JSON.parse response

    if departures.empty?
      "Inga avgångar finns för hållplats #{stop_id}"
    else
      haml :stop_information, locals: { departures: departures }
    end
  end

  def stations_by_name query
    # this endpoint was found by inspecting the station search at SLs home page
    escaped_query = CGI.escape query  
    RestClient.get "https://webcloud.sl.se/api/travellocations?search=#{escaped_query}&type=1&mode=cors"
  end
end


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


# the weather forecast is retreieved from SMHI.
# documentation is here: http://opendata.smhi.se/apidocs/metfcst/index.html
#
# the forecast is updated once an hour
module WeatherForecast
  include SMHI
  
  def present_weather_forecast lat, lon
    forecasts = hourly_forecasts lat, lon, 20
    haml :forecast, locals: { data: forecasts }
  end
end

module ParamsHandling
  def parse params
    result = {}
    result[:stops] = parse_stops params['stops']
    result[:lat], result[:lon] = parse_coordinates params

    result
  end
  
  def parse_stops stops_param
    stops = stops_param
    stops ||= '9143,1577'
    stops.split ','
  end

  def parse_coordinates params
    lat = params[:lat]
    lon = params[:lon]
    coordinates_present = lat and lon

    coordinates_present ? [lat, lon] : [LAT, LON]
  end
end

class Bubonem < Sinatra::Base
  include SunMachine
  include CommuteInformation
  include WeatherForecast
  include ParamsHandling

  # turns off the default layout - now needs to be set
  # explicitly by the routes that are using it
  set :haml, layout: false


  ###################################
  # PAGES ##########################
  ###################################
  
  get '/' do
    haml :index, locals: {scripts: ['add-stop', 'link-calculator']}, layout: :layout
  end

  get '/dash' do
    haml :dash, locals: parse( params ), layout: :layout
  end


  ###################################
  # DASHBOARD FRAGMENTS #############
  ###################################

  get '/stop/:stop_id' do |stop_id|
    present_stop_information stop_id
  end

  get '/weather_forecast' do
    present_weather_forecast params['lat'], params['lon']
  end

  get '/current_time' do
    DateTime.now.in_stockholm.strftime '%Y-%m-%d %k:%M'
  end

  get '/sun' do
    "up: #{sunrise.viewable_time_of_day} &middot; down: #{sunset.viewable_time_of_day}"
  end


  ###################################
  # CONFIG HELPERS  #################
  ###################################

  
  get '/stations/:query' do |query|
    station_list = JSON.parse stations_by_name query
    haml :station_list_fragment, locals: {station_list: station_list}
  end

end


