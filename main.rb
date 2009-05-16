require 'rubygems'
require 'sinatra'
require 'haml'
require 'lib/db'

get '/' do
  "<h1>A walking blog</h1>"
end
