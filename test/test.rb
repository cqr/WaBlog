require 'main'
require 'bacon'
require 'sinatra/test'

set :environment, :test

class Bacon::Context
  include Sinatra::Test
end

describe "Our Walking Blog" do
  
  it 'gives our default page' do
    get '/'
    response.should.be.ok
    body.should.equal "<h1>A walking blog</h1>"
  end

end