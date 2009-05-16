class Post
  property :id, Serial
  property :title, String
  property :slug, String
  has n, :folksonomies
  has n, :tags, :through => :folksonomies
  has n, :footprints
end
