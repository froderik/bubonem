require 'rubygems'
require 'bundler'

Bundler.require
require 'solareventcalculator'

require './smhi'
require './bubonem'
run Bubonem
