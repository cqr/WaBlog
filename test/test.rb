require 'rubygems'
require 'test/unit'
require 'main'
require 'sinatra/test'

set :environment, :test

class WaBlogTest < Test::Unit::TestCase
  include Sinatra::Test
  
  def test_displays_welcome_page
    get '/'
    assert ok?
    assert_equal("<h1>A walking blog</h1>", body)
  end
  
end