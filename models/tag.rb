class Tag
  property :id, Serial
  property :name, String
  has n, :folksonomies
  has n, :posts, :through => :folksonomies
  
  def to_s
    name
  end
end
