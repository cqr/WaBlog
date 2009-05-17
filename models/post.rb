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
  
  def revisions
    footprints.size
  end
  
  def body(revision = revisions)
    footprints[revision-1].body if revisions > 0
  end
  
  def revision(revision = revisions)
    footprints[revision-1] if revisions > 0
  end
  
  def body=(new_body)
    body_text, permanent = new_body
    if revision.nil? or
        (revision.created_at and revision.created_at.minutes_ago >=5) or
        revision.permanent?
      footprints << Footprint.new(:body => body_text,
        :overwritable => (permanent != :permanent))
    else
      revision.body = body_text
    end
    body_text
  end
  
  def to_html(revision = revisions)
    footprints[revision-1].to_html
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
  
  
  def inspect
    "#<Post id=#{id||'nil'} title=#{title||'nil'} " +
    "slug=#{slug||'nil'} body=#{body||'nil'} revisions=" +
    "#{revisions}>"
  end
  
end
class DateTime
  def minutes_ago
    hours, minutes, seconds = Date.day_fraction_to_time(DateTime.now - self)
    hours*60 + minutes
  end
end