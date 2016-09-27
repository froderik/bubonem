# coding: utf-8
require 'sinatra'
require 'json'

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
    the_data = JSON.parse(response)["data"]["BusGroups"].first
    haml :stop_information, locals: { data: the_data }
  end


  # weather forecast

  def present_weather_forecast
    response = RestClient.get 'http://opendata-download-metfcst.smhi.se/api/category/pmp2g/version/2/geotype/point/lon/17.96/lat/59.44/data.json'
    the_data = JSON.parse(response)
    haml :forecast, locals: { data: the_data }
  end
  
end


