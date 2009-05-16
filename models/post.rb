class Post
  property :id, Serial
  property :title, String
  property :slug, String
  has n, :folksonomies
  has n, :tags, :through => :folksonomies
  has n, :footprints
  
  before :save, :sluggify
  
  def slug=(slug)
    attribute_set :slug,
        slug.downcase.gsub(/ /, '_').gsub(/[^a-z0-9_]/, '').squeeze('_')
  end
  
  def sluggify
    self.slug= @title if slug.nil? or slug == ''
  end
  
end
