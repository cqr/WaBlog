require 'rubygems'
require 'datamapper'
DataMapper.setup :default,
  "sqlite3::memory:"  
  #"sqlite3://#{File.dirname(__FILE__)}/../db/wablog.db"

models = Dir.entries(File.dirname(__FILE__)+'/../models').map do |f|
  f.to_s.sub(/\.rb$/,'') unless f.to_s =~ /^\./
end.compact

models.each do |model|
  Object.const_set model.capitalize, Class.new
  Object.const_get(model.capitalize).instance_eval do
    include DataMapper::Resource
  end
end
models.each { |m| require "#{File.dirname(__FILE__)}/../models/#{m}" }
DataMapper.auto_migrate!
