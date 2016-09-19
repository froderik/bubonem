require 'sinatra'

class Bubonem < Sinatra::Base

  get '/' do
    haml :index
  end
  
end
