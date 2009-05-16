require 'test/base'

class Bacon::Context
  include Sinatra::Test
end

describe "Blog" do
  
  it 'provides a default page' do
    get '/'
    response.should.be.ok
    body.should.equal "<h1>A walking blog</h1>"
  end

end
