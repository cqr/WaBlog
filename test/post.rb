require 'test/base'
describe Post do
  
  @post = Post.new

  it "can be created as an empty Post Object" do
    @post.title.should.be.nil
    @post.tags.should.equal []
    @post.slug.should.be.nil
    @post.footprints.should.equal []
  end

  it "can have it's attributes updated and read" do
    @post.title = 'a testing post'
    @post.slug = 'test'
    @post.title.should.equal 'a testing post'
    @post.slug.should.equal 'test'
  end

  it "can be saved and read from the database" do
    @post.save
    Post.get(@post.id).should.equal @post
  end
  
  it "handles sluggifys on setting slug" do
    @post.slug = 'My Little Sample Slug + All  that J4zz'
    @post.slug.should.equal 'my_little_sample_slug_all_that_j4zz'
  end
  
  it "automatically creates a slug from title" do
    @post = Post.new
    @post.title = 'A Test Post'
    @post.save
    @post.slug.should.equal 'a_test_post'
    Post.get(@post.id).slug.should.equal 'a_test_post'
  end
  
end
