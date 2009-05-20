require 'rubygems'
require 'sinatra'

Sinatra::Application.set  :run => false
Sinatra::Application.set  :environment => :production

require 'main'
run Sinatra::Application
