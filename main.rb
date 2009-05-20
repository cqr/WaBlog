require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
configure :production do
  $config = {

    # Basic configuration stuff...
    :author => "chrisrhoden",
    :logo   => "/nvrfrgt.png",
    :title  => "nvr.frgt.me",
    :web    => "http://chrisrhoden.com",

    # If you would rather connect to a MySQL database, 
    # you can do something like mysql://localhost/db_name
    :database => "sqlite3:///#{Dir.pwd}/db/wablog.db",
    
    # you can create your own templates by figuring out
    # what is going on here pretty easily. check the
    # templates directory.
    :template => 'default'
    
  }
  set :views, Proc.new { File.join(root, "templates/#{$config[:template]}.tpl") }
  require 'lib/db'
end

configure :test do
  $config = {
    :author => 'Name',
    :database => 'sqlite3::memory:',
    :template => 'default'
  }
end

helpers do
  def file_not_found
    halt 404, '<h1>404 - File not found</h1>'
  end
  def is_logged_in?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
  end
  def require_login
    response['WWW-Authenticate'] = %(Basic realm="Testing HTTP Auth") and \
    throw(:halt, [401, "Not authorized\n"]) and \
    return unless is_logged_in?
  end
end

get '/' do
  @posts = Post.all(:order => [:id.desc])
  haml :index, :layout => false
end

get '/posts/new/?' do
  require_login
  @post = Post.new(:body => '')
  haml :new
end

get '/posts/:slug/?' do
  @post = Post.first(:slug => params['slug'])
  file_not_found unless @post
  haml :post
end

get '/posts/:slug/history/?' do
  @post = Post.first(:slug => params['slug'])
  file_not_found unless @post
  haml :history
end

get '/posts/:slug/edit/?' do
  require_login
  @post = Post.first(:slug => params['slug'])
  file_not_found unless @post
  haml :edit
end

put '/posts/:id/?' do
  require_login
  @post = Post.get(params['id'])
  file_not_found unless @post
  @post.title = params['title'] if params['title']
  @post.body = params['body'] if params['body']
  @post.slug = params['slug'] if params['slug']
  @post.tags = params['tags'] if params['tags']
  if @post.save
    redirect '/posts/' + @post.slug
  else
    haml :edit
  end
end

put '/posts/:id.ajax' do
  require_login
  @post = Post.get(params['id'])
  file_not_found unless @post
  @post.title = params['title'] if params['title']
  @post.body = params['body'] if params['body']
  @post.slug = params['slug'] if params['slug']
  @post.tags = params['tags'] if params['tags']
  if @post.save
    halt 200, @post.updated_at
  else
    halt 500, "NO-GO"
  end
end
post '/posts/?' do
  require_login
  @post = Post.new()
  @post.title = params['title']
  @post.slug = params['slug']
  @post.tags = params['tags']
  if @post.save
    redirect "/posts/#{@post.slug}/edit"
  else
    haml :new
  end
end

get '/tags/:tag/?' do
  @tag = Tag.first(:name => params['tag'])
  @posts = @tag.posts(:order => [:id.desc]) if @tag
  file_not_found unless @posts
  haml :tag
end

get '/:stylesheet.css' do
  sass params[:stylesheet].intern
end
