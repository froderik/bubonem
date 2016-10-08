# coding: utf-8
require 'sinatra'
require 'json'
require 'solareventcalculator'


LON = '17.96'
LAT = '59.44'
ZONE = 'Europe/Stockholm'

module SunMachine
  def sunrise
    sun_machine.compute_civil_sunrise ZONE
  end

  def sunset
    sun_machine.compute_civil_sunset ZONE
  end

  def sun_machine
    SolarEventCalculator.new Date.today, BigDecimal.new(LAT), BigDecimal.new(LON)
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

  def day_or_night?
    if self > sunrise and self < sunset
      :day
    else
      :night
    end
  end
end

class Bubonem < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/edsbergsskolan' do
    present_stop_information 5518
  end

  get '/axroad' do
    present_stop_information 5515
  end

  get '/weather_forecast' do
    present_weather_forecast
  end


  # bus information
  
  def present_stop_information stop_id
    response = RestClient.get "http://sl.se/api/sv/RealTime/GetDepartures/#{stop_id}"
    the_data = JSON.parse(response)['data']['BusGroups'].first
    haml :stop_information, locals: { data: the_data }
  end


  # weather forecast

  OneForecast = Struct.new :time, :celsius, :symbol do
    def day_or_night
      time.day_or_night?
    end
  end

  def weather_url
    "http://opendata-download-metfcst.smhi.se/api/category/pmp2g/version/2/geotype/point/lon/#{LON}/lat/#{LAT}/data.json"
  end

  def present_weather_forecast
    # documentation here: http://opendata.smhi.se/apidocs/metfcst/index.html
    response = RestClient.get weather_url
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


