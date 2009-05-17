class Footprint
  property :id, Serial
  property :body, Text
  property :created_at, DateTime
  property :overwritable, Boolean, :default => true
  belongs_to :post
  
  def dont_overwite
    overwritable = false
    save
  end
  
  def permanent?
    !overwritable?
  end
  
  alias_method :overwritable?, :overwritable
end
