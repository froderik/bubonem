require 'rubygems'
require 'bundler'

Bundler.require
require 'solareventcalculator'

require 'dotenv/load'

require './smhi'
require './bubonem'
run Bubonem
