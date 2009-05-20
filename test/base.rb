require 'rubygems'
require 'datamapper'
require 'sinatra'
Sinatra::Application.set :environment, :test
require 'main'
require 'bacon'
require 'sinatra/test'
require 'lib/db'
