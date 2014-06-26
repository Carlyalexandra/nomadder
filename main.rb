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

#inside of your view
# =current_user
# =display_one


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
  @user = User.find(session[:user_id])
  @postsall = Post.all.order(date: :desc).limit(10)
  erb :logged_in
end


get '/profile' do
   @title = "Profile Page"
   @posts = current_user.posts.order(date: :desc).limit(10)
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

get '/profile' do
  erb :profile
end

