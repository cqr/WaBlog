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
end
