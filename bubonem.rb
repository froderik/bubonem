# coding: utf-8

LAT = '59.29'
LON = '18.11'
ZONE = 'Europe/Stockholm'
ORNAMENT = 'matrix'

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

    api_key = ENV['SL_API_KEY_DEPARTURES']
    
    response = RestClient.get "https://transport.integration.sl.se/v1/sites/#{stop_id}/departures"

    unless response.code == 200
      return "Problem med kod #{response.code} från API"
    end

    parsed_response = JSON.parse( response )
    departures = parsed_response['departures']
    unless departures
      return "No departures\n#{response}"
    end
    sorted_departures = departures.sort_by { |d| d['expected'] or d['scheduled'] }

    if sorted_departures.empty?
      "Inga avgångar finns för hållplats #{stop_id}"
    else
      haml :stop_information, locals: { departures: sorted_departures }
    end
  end

  def stations_by_name query
    escaped_query = CGI.escape query
    url = 'journeyplanner.integration.sl.se/v1/typeahead.json'
    RestClient.get "https://#{url}?key=TRAFIKLAB-SLAPI-INTEGRATION-2024&searchstring=#{escaped_query}"
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
  def ornament
    params.fetch(:ornament, ORNAMENT)
  end

  def parse params
    result = {}
    result[:stops] = parse_stops params['stops']
    result[:lat], result[:lon] = parse_coordinates params
    result[:ornament] = ornament

    result
  end
  
  def parse_stops stops_param
    stops = stops_param
    stops ||= '9180,1916,1912'
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
  set :haml, layout: false, escape_html: false


  ###################################
  # PAGES ##########################
  ###################################
  
  get '/' do
    scripts = ['add-stop', 'link-calculator']
    locals = {scripts: scripts, ornament: ornament}
    haml :index, locals: locals, layout: :layout
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
    fmt = params['fmt'] || '%Y-%m-%d %k:%M'
    DateTime.now.in_stockholm.strftime fmt
  end

  get '/sun' do
    "up: #{sunrise.viewable_time_of_day} &middot; down: #{sunset.viewable_time_of_day}"
  end


  ###################################
  # CONFIG HELPERS  #################
  ###################################

  
  get '/stations/:query' do |query|
    station_list_response = JSON.parse stations_by_name query
    station_list = station_list_response['ResponseData']
    haml :station_list_fragment, locals: {station_list: station_list}
  end

end


