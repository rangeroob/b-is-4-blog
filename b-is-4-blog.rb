require 'cuba'
require 'rack/protection'
require "cuba/render"
require 'erb'
require 'sequel'
require 'date'


Cuba.use Rack::Session::Cookie, :secret => "wVmZ0Xk+AUsBTA55YIjLLzWNUlk/jnTnU7orZ5vAAeQqVi0iOe3pex/7jtIKh9+RaJ/IBwBubKjna5zQ2tLkKA=="
Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

  # connect to a database
DB = Sequel.connect('sqlite://db/blog.db', :max_connections=>200)


# create a dataset from the items table
   posts = DB[:posts]

  Cuba.use Rack::Static, root: "public", urls: ["/css"]
  Cuba.use Rack::Static, root: "public", urls: ["/imgs"]
  Cuba.use Rack::Static, root: "public", urls: ["/js"]

  Cuba.plugin(Cuba::Render)

  Cuba.settings[:render][:template_engine] = "erb"
  Cuba.settings[:render][:views] = "./views"

Cuba.define do
  on get do

    on root do
      @css = "<link rel='stylesheet' type='text/css' href='/css/style.css'>"
      where_post =  posts.where[:title => 'Lorem ipsum dolor sit amet']
      @title = where_post.fetch(:title)
      @front_body = where_post.fetch(:body)
      @footer = "&copy Derek Viera"
      res.write view("layout")
    end

  on "articles" do
	  where_post =  posts.where[:id => 2]
	  @title = where_post.fetch(:title)
    @css = "<link rel='stylesheet' type='text/css' href='/css/style.css'>"
	  res.write partial ("articles")
	end

	on "search", param("search") do |query|
	  @css = "<link rel='stylesheet' type='text/css' href='/css/style.css'>"
	  where_post = posts.where[:id => "#{query}"]
	  @title = where_post.fetch(:title)
      res.write partial ("articles")
    end
    end
end
