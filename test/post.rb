require 'test/base'
puts $config[:database]
describe Post do
  
  Post.all.each {|p| p.destroy }
  it "can be created as an empty Post Object" do
    p = Post.new
    p.title.should.be.nil
    p.tags.should.equal []
    p.slug.should.be.nil
    p.footprints.should.equal []
  end

  it "can have its attributes updated and read" do
    p = Post.new
    p.title = 'a testing post'
    p.slug = 'test'
    p.title.should.equal 'a testing post'
    p.slug.should.equal 'test'
  end

  it "can be saved and read from the database" do
    p = Post.new
    p.save.should.equal false
    p.title = 'test read write'
    p.save
    Post.get(p.id).should.equal p
  end
  
  it "handles sluggifys on setting slug" do
    p = Post.new
    p.slug = 'My Little Sample Slug + All  that J4zz'
    p.slug.should.equal 'my_little_sample_slug_all_that_j4zz'
  end
  
  it "automatically creates a slug from title" do
    p = Post.new
    p.title = 'A Test Post'
    p.save
    p.slug.should.equal 'a_test_post'
    Post.get(p.id).slug.should.equal 'a_test_post'
  end
  
  it "allows adding and removing tags" do
    p = Post.new(:title => 'arghragh')
    p.add_tag('ducky')
    p.tags.first.name.should.equal 'ducky'
    p.remove_tag('ducky')
    p.tags.should.equal []
    p.add_tag('a')
    p.tags = 'r b c d'
    p.tags.size.should.equal 4
    p.tags.should.not.include 'a'
  end
  
  it "allows adding footprints" do
    p = Post.new(:title => 'test footprints')
    p.body = "some text"
    p.body.should.equal "some text"
  end
  
  it "overwrites footprints which are less than 5 minutes old" do
    p = Post.new(:title => 'test overwrite')
    p.body = "a"
    p.revisions.should.equal 1
    p.body = "b"
    p.revisions.should.equal 1
    p.body.should.equal "b"
  end
  
  it "does not overwrite locked footprints, even < 5 mintues old" do
    p = Post.new(:title => 'test dont lock')
    p.body = "a", :permanent
    p.body = "b"
    p.revisions.should.equal 2
    p.body.should.equal "b"
    p.body(-1).should.equal "a"
  end
  
  it "does not overwrite footprints > 5 minutes old" do
    p = Post.new(:title => 'test do lock')
    p.body = 'a'
    p.revision.created_at = DateTime.civil
    p.body = 'b'
    p.revisions.should.equal 2
    p.body.should.equal 'b'
    p.body(1).should.equal 'a'
  end
end