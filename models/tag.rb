class Tag
  property :id, Serial
  property :name, String
  has n, :folksonomies
  has n, :posts, :through => :folksonomies, :mutable => true
end
