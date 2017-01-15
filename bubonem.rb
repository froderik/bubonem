# coding: utf-8
require 'sinatra'
require 'json'
require 'solareventcalculator'


LON = '17.96'
LAT = '59.44'
ZONE = 'Europe/Stockholm'

module SunMachine
  def sunrise date = Date.today
    sun_machine(date).compute_official_sunrise ZONE
  end

  def sunset date = Date.today
    sun_machine(date).compute_official_sunset ZONE
  end

  def sun_machine date
    SolarEventCalculator.new date, BigDecimal.new(LAT), BigDecimal.new(LON)
  end
end

class DateTime
  include SunMachine
  
  def is_future?
    self > DateTime.now
  end

  def in_stockholm
    sthlm_zone.utc_to_local self
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
    strftime '%k:%M'
  end
end

module BusInformation
  def present_stop_information stop_id
    response = RestClient.get "http://sl.se/api/sv/RealTime/GetDepartures/#{stop_id}"
    the_data = JSON.parse(response)['data']['BusGroups'].first
    haml :stop_information, locals: { data: the_data }
  end

  def stations_by_name query
    RestClient.get "http://sl.se/api/TypeAhead/Find/#{query}/true"
  end
end

module WeatherForecast
    OneForecast = Struct.new :time, :celsius, :symbol do
    def day_or_night
      time.day_or_night?
    end
  end

  def weather_url lat, lon
    "http://opendata-download-metfcst.smhi.se/api/category/pmp2g/version/2/geotype/point/lon/#{lon}/lat/#{lat}/data.json"
  end

  def present_weather_forecast lat, lon
    # documentation here: http://opendata.smhi.se/apidocs/metfcst/index.html
    response = RestClient.get weather_url(lat, lon)
    the_data = JSON.parse response
    list_of_forecasts = parse_raw_into_forecasts the_data
    haml :forecast, locals: { data: list_of_forecasts }
  end

  def parse_raw_into_forecasts smhi_data
    time_series = smhi_data['timeSeries']
    all_forecasts = time_series.map do |one_point_in_time|
      params = one_point_in_time['parameters']
      forecast = OneForecast.new
      forecast.time = DateTime.parse( one_point_in_time['validTime'] )
      forecast.celsius = find_value 't', params
      forecast.symbol = find_value 'Wsymb', params
      forecast
    end

    future_forecasts = all_forecasts.select { |forecast| forecast.time.is_future? }
    future_forecasts[0..20]
  end

  def find_value name, params
    the_one = params.detect { |p| p['name'] == name }
    the_one['values'].first
  end
end

module ParamsHandling
  def parse params
    result = {}
    result[:bus_stops] = parse_bus_stops params['bus_stops']
    result[:lat], result[:lon] = parse_coordinates params
    result[:mapw] = params['mapw'] || 850
    result[:maph] = params['maph'] || 850

    result
  end
  
  def parse_bus_stops bus_stops_param
    bus_stops = bus_stops_param
    bus_stops ||= '5518,5515'
    bus_stops.split ','
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
  include BusInformation
  include WeatherForecast
  include ParamsHandling

  get '/dash' do
    haml :index, locals: parse( params )
  end

  get '/bus_stop/:stop_id' do |stop_id|
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

  get '/stations/:query' do |query|
    stations_by_name query
  end

end


