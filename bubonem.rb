require 'sinatra'

class Bubonem < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/edsbergsskolan' do
    "yadiolololo"
  end
  
end
