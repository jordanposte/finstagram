helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  @posts = Post.order(created_at: :desc)
  # Removed this because replaced it with helper method do didn't have to repeat it multiple times across all 
  # requests @current_user = User.find_by(id: session[:user_id]) #reuired so we can display username at top of screen (see html)
  erb(:index)   
end

get '/signup' do      # if a user nagigates to the path "/signup",
  @user = User.new    # setup empty @user object
  erb (:signup)       # render "app/views/signup.erb"
end

post '/signup' do
  
  # grab user input values from params
  email      = params[:email]
  avatar_url = params[:avatar_url]
  username   = params[:username]
  password   = params[:password]
  
  # instantiate a User
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
  
  #if user validations pass and user is saved
  if @user.save
    redirect to('/login') #will trigger the get '/login' action and thus setting @user = User.new and rendering out login.erb
  else
    erb(:signup)
  end
  
end
  
get '/login' do # when a GET request comes into /login
  erb(:login)   # render app/views/login.erb
end
 
post '/login' do  
    #params.to_s    # just display the params for now to make sure it's working 
  username = params[:username]
  password = params[:password]
  
  # 1. find user by username
  user = User.find_by(username: username)
  
  if user && user.password == password
      session[:user_id] = user.id
      redirect to ('/') # will trigger get '/' in actions.rb setting @posts and rendering index.erb (note: requests go to paths not files)
      # removed this because want to be redirected to home page instead of message displayed...  "Success! User with id #{session[:user_id]} is logged in!"
    else
      @error_message = "Login failed."
      erb(:login)
    end

end

get '/logout' do
  session[:user_id] = nil
  redirect to ('/')
end
  
get '/posts/new' do
  @post = Post.new
  erb(:"posts/new")
end
  
post '/posts' do
  photo_url = params[:photo_url]
  
  #instantiate new Post
  @post = Post.new({ photo_url: photo_url, user_id: current_user.id })
  
  #if @post validates, save
  if @post.save
    redirect(to('/'))
  else
    erb(:"posts/new")
  end
end
  
get '/posts/:id' do
  @post = Post.find(params[:id]) # find the post with the ID from the URL
  erb(:"posts/show")              # render app/views/posts/show.erb
end
  
  
  
  
=begin OLD CODE TO DELETE BECAUSE OF ACTIVE RECORD SETUP
    @post_shark = {
        username: "sharky_j",
        avatar_url: "http://naserca.com/images/sharky_j.jpg",
        photo_url: "http://naserca.com/images/shark.jpg",
        humanized_time_ago: humanized_time_ago(15),
        like_count: 0,
        comment_count: 1,
        comments: [{
          username: "sharky_j",
          text: "sharky_j Out for the long weekend... too embarrassed to show y'all the beach bod!"
        }]
    }
     
        @post_whale = {
        username: "kirk_whalum",
        avatar_url: "http://naserca.com/images/kirk_whalum.jpg",
        photo_url: "http://naserca.com/images/whale.jpg",
        humanized_time_ago: humanized_time_ago(65),
        like_count: 0,
        comment_count: 1,
        comments: [{
          username: "kirk_whalum",
          text: "#weekendvibes"
        }]
    }
    
        @post_marlin = {
        username: "marlin_peppa",
        avatar_url: "http://naserca.com/images/marlin_peppa.jpg",
        photo_url: "http://naserca.com/images/marlin.jpg",
        humanized_time_ago: humanized_time_ago(190),
        like_count: 0,
        comment_count: 1,
        comments: [{
          username: "marlin_peppa",
          text: "lunchtime! ;)"
        }]
    }
    
    @posts = [@post_shark, @post_whale, @post_marlin]

=end 
    
