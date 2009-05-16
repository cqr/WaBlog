class Tag
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  has n, :folksonomies
  has n, :posts, :through => :folksonomies
end
