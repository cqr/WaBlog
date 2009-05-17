require 'test/base'
describe Post do
  

  it "can be created as an empty Post Object" do
    p = Post.new
    p.title.should.be.nil
    p.tags.should.equal []
    p.slug.should.be.nil
    p.footprints.should.equal []
  end

  it "can have it's attributes updated and read" do
    p = Post.new
    p.title = 'a testing post'
    p.slug = 'test'
    p.title.should.equal 'a testing post'
    p.slug.should.equal 'test'
  end

  it "can be saved and read from the database" do
    p = Post.new
    p.save.should.equal false
    p.title = 'a'
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
    p = Post.new(:title => 'a')
    p.add_tag('ducky')
    p.tags.first.name.should.equal 'ducky'
    p.remove_tag('ducky')
    p.tags.should.equal []
  end
  
end
