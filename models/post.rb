require 'lib/html_diff'
class Post
  property :id, Serial
  property :title, String, :nullable => false
  property :slug, String, :unique => true, :nullable => false
  has n, :folksonomies
  has n, :tags, :through => :folksonomies
  has n, :footprints
  
  before :valid?, :sluggify
  before :save, :auto_footprint
  before :destroy, :remove_footprints
  
  def slug=(slug)
    attribute_set :slug,
        slug.downcase.gsub(/ /, '_').gsub(/[^a-z0-9_]/, '').squeeze('_') unless slug.nil?
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
  
  def diff_html(reva = nil, revb = nil)
    reva ||= revisions-1
    revb ||= revisions
    HTMLDiff.diff(revision(reva).to_html, revision(revb).to_html)
  end
  
  def body=(new_body)
    body_text, permanent = new_body
    if revision.nil? or
        (revision.created_at and revision.created_at.minutes_ago >=1) or
        revision.permanent?
      footprints << Footprint.new(:body => body_text,
        :permanent => (permanent == :permanent))
    else
      revision.body = body_text
    end unless (revision and revision.body == body_text)
    body_text
  end
  
  def updated_at
    revision.updated
  end
  
  def to_html(revision = revisions)
    footprints[revision-1].to_html
  end
  
  # add_tag and remove_tag are hacky, and shouldn't be necessary, but
  # the datamapper many-to-many implementation appears to be a bit
  # screwy at the moment, so we'll go with this.
  def add_tag(tag) 
    create_tag_link(tag)
    save; tags.reload
    tag
  end
  
  def add_tags(t)
    t.each do |tag|
      create_tag_link(tag)
    end
    save; tags.reload
    true
  end
  
  def remove_tag(tag)
    destroy_tag_link(tag)
    tags.reload
  end
  
  def remove_tags(t)
    t.each do |tag|
      destroy_tag_link(tag)
    end
    save; tags.reload
    true
  end
  
  def create_tag_link(tag)
    folksonomies.build(:tag_id => Tag.first_or_create(:name => tag.to_s).id)
  end
  
  def destroy_tag_link(tag)
    r = Folksonomy.first :post_id => id,
        :tag_id => (t = Tag.first(:name=>tag.to_s)).id
    r.destroy unless r.nil?;
  end
  
  def read_tags
    tags.map{|t|t.name}.join(' ') unless tags.empty?
  end
  
  def tags=(tags)
    remove_tags(self.tags)
    add_tags(tags.split(' '))
  end
  
  private
  def sluggify
    self.slug= @title if slug.nil? or slug == ''
  end
  
  def auto_footprint
    footprints << Footprint.new(:body => '') if footprints.size == 0
  end
  
  def remove_footprints
    footprints.each {|f| f.destroy}
  end
  
  public
  def inspect
    "#<Post id=#{id||'nil'} title=#{title||'nil'} " +
    "slug=#{slug||'nil'} body=#{body.inspect[1..20]||'nil'} revisions=" +
    "#{revisions}>"
  end
  
end
class DateTime
  def minutes_ago
    hours, minutes = Date.day_fraction_to_time(DateTime.now - self)
    hours*60 + minutes
  end
end
