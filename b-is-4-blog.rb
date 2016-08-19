require 'cuba'
require 'rack/protection'
require "cuba/render"
require 'erb'
require 'sequel'

Cuba.use Rack::Session::Cookie, :secret => "wVmZ0Xk+AUsBTA55YIjLLzWNUlk/jnTnU7orZ5vAAeQqVi0iOe3pex/7jtIKh9+RaJ/IBwBubKjna5zQ2tLkKA=="
Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

  # connect to an in-memory database
DB = Sequel.sqlite

# create an items table
DB.create_table :posts do
  primary_key :id
  String :title
  String :body
  String :date
end

# create a dataset from the items table
   posts = DB[:posts]

# populate the table
  posts.insert( :title => 'Lorem ipsum dolor sit amet', :body => '

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed suscipit mi, vel porttitor felis. Praesent feugiat ullamcorper vestibulum. Duis iaculis mauris id dui viverra, at tincidunt ipsum sagittis. Nunc fermentum lorem quis lacus rhoncus venenatis cursus vitae purus. Nulla quis ligula semper, mollis risus at, ultricies nisl. Aenean viverra sollicitudin maximus. Sed molestie scelerisque tortor sed feugiat. Sed facilisis eros risus, a accumsan ex sagittis in.

Ut est leo, sodales sit amet eros eu, ullamcorper laoreet velit. Aenean commodo sagittis nisi in ullamcorper. Cras in quam nibh. In pellentesque cursus justo, non consectetur enim lobortis vel. Nulla facilisi. Quisque ut luctus nulla. Nunc interdum dolor quis diam volutpat vulputate. Fusce quis egestas lectus. Duis dolor tellus, pulvinar id ipsum in, bibendum vestibulum lacus.

Vivamus at finibus sem, vel finibus libero. Nulla aliquet arcu mauris, a vehicula nisi egestas non. Nulla facilisi. Mauris pulvinar dui vitae euismod ultricies. Donec blandit est a finibus lobortis. Sed varius interdum arcu, quis ornare nisi auctor eu. Aenean in ex aliquam, congue urna vitae, cursus est. Donec fringilla orci ac neque fermentum, eget aliquam nibh tristique. Pellentesque sit amet erat suscipit, gravida diam quis, vulputate dolor.

Ut tempus porttitor erat a mattis. Sed a ipsum pellentesque, maximus nulla sed, aliquet purus. Praesent malesuada ut nisl et varius. Phasellus dapibus massa magna, vitae egestas elit vehicula quis. Vivamus sollicitudin justo sit amet lobortis finibus. Donec id porta tellus, eu aliquam quam. Pellentesque elementum turpis sit amet tellus ornare pharetra. Sed pretium in risus sed vestibulum.

Duis molestie vel purus ut fermentum. Nunc et vulputate diam. Aenean pellentesque porta enim. Nulla congue tellus nulla, non pretium velit tempus in. Nam eu quam orci. Morbi tortor elit, rutrum at arcu ac, ultrices sagittis nunc. Suspendisse pellentesque blandit risus sed vestibulum. Integer interdum scelerisque sem, ac pulvinar ipsum eleifend quis. Suspendisse et ex at sem ullamcorper suscipit eget id diam. Sed et gravida nibh, at aliquet velit. Proin ac lacus et dolor pharetra molestie quis et elit.

Etiam augue lacus, pharetra ut lacus eleifend, tristique consequat arcu. In tortor dolor, semper vitae interdum sit amet, vestibulum ac mi.')


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
  
  end
end

