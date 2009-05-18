require 'rubygems'
require 'datamapper'
$config ||= {}
$config[:database] ||= "sqlite3:///#{Dir.pwd}/db/wablog.db"

DataMapper.setup :default, $config[:database]
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
models.each do |m|
  o = Object.const_get(m.capitalize)
  o.auto_upgrade!
end
