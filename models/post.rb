class Post
  property :id, Serial
  property :title, String, :nullable => false
  property :slug, String
  has n, :folksonomies
  has n, :tags, :through => :folksonomies, :mutable => true
  has n, :footprints
  
  before :save, :sluggify
  
  def slug=(slug)
    attribute_set :slug,
        slug.downcase.gsub(/ /, '_').gsub(/[^a-z0-9_]/, '').squeeze('_')
  end
  
  
  # add_tag and remove_tag are hacky, and shouldn't be necessary, but
  # the datamapper many-to-many implementation appears to be a bit
  # screwy at the moment, so we'll go with this.
  def add_tag(tag)
    folksonomies.build(:tag_id => (tag = Tag.create(:name => tag.to_s)).id)
    save; tags.reload
    tag
  end
  
  def remove_tag(tag)
    r = Folksonomy.first :post_id => @id,
        :tag_id => (t = Tag.first(:name=>tag.to_s)).id
    r.destroy unless r.nil?; t.posts.reload unless t.nil?
    tags.reload
  end
  
  def sluggify
    self.slug= @title if slug.nil? or slug == ''
  end

  
end
