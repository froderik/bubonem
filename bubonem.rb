# coding: utf-8
require 'sinatra'

class Bubonem < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/edsbergsskolan' do
    "yadiolololo"
  end

  get '/axroad' do
    "yololo"
  end
  
end
