require 'maruku'
require 'syntax/convertors/html'
class Footprint
  property :id, Serial
  property :body, Text
  property :created_at, DateTime
  property :updated_at, DateTime
  property :permanent, Boolean, :default => false
  belongs_to :post
  
  def dont_overwite
    permanent = true
    save
  end
  
  def to_html
    h = Maruku.new(body).to_html
    h.gsub(/<code>([^<]+)<\/code>/m) do
      convertor = Syntax::Convertors::HTML.for_syntax "ruby"
      highlighted = convertor.convert($1)
      "<code>#{highlighted}</code>"
    end
  end
  
  def overwritable?
    !permanent?
  end
  
  def updated
    updated_at.strftime('%A, %b %d, %H:%M:%S')
  end
  
  alias_method :permanent?, :permanent
end
