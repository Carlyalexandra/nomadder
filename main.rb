require 'sinatra'
require 'sinatra/activerecord'
require './models'

require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash' 

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true
configure(:development){set :database, "sqlite3:nomdder_app.sqlite3"}

helpers do
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
  end
end



class UsersController 
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
end

class RelationshipsController 
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
  end
end


get '/' do
  @title = "Welcome to Nomadder"
  erb :sign_in, :layout => false
end

post '/signup' do
  @user = User.create(params[:user])
  flash[:notice] = 'New account created'
  session[:user_id] = @user.id
  redirect '/logged_in'
end

post '/signin' do
  @user = User.where(params[:user]).first
  if !@user
    flash[:alert] = "Sorry, that user doesn't exist. Feel free to sign up."
    redirect '/'
  else
    flash[:notice] = "You've successfully signed in."
    session[:user_id] = @user.id
    redirect '/logged_in'
  end
end

get '/sign_out' do
   session[:user_id] = nil
   redirect '/'
end

get '/logged_in' do
  @title = "Welcome to Nomadder"
  @user = User.find(session[:user_id]) if session[:user_id]
  @postsall = Post.all.order(date: :desc).limit(10)
  erb :logged_in
end


get '/profile' do
   @title = "Profile Page"
   @user = User.find(session[:user_id]) if session[:user_id]
   @posts = current_user.posts.order(date: :desc).limit(10)
    erb :profile
end

post '/post' do
  puts params.inspect
  @post = Post.new(params[:post])
  @post.date = DateTime.now
  @post.user_id = current_user.id
  @post.save
  #@user = User.find(session[:user_id])
  #session[:user_id] = @user.id

  redirect '/logged_in'
end

get '/account_setting' do
  @title = "Account Settings"
  erb :account_settings
end


