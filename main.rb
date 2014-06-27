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

get '/follow/:id' do
    @relationships = Relationship.new(follower_id: current_user.id, followed_id: params[:id])
    if @relationships.save
      flash[:notice] = "You've successfully followed #{User.find(params[:id]).fname}."
    else
      flash[:alert] = "There was an error following that user."
    end
    redirect back
end

get '/profile' do
   @title = "Profile Page"
   @user = User.find(session[:user_id]) if session[:user_id]
   @posts = current_user.posts.order(date: :desc)
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

post '/post_profile' do
  puts params.inspect
  @post = Post.new(params[:post])
  @post.date = DateTime.now
  @post.user_id = current_user.id
  @post.save
  redirect '/profile'
end

get '/account_setting' do
  @title = "Account Settings"
  @user = User.find(session[:user_id]) if session[:user_id]
  erb :account_settings
end

get '/users/:id' do
  @user = User.find(params[:id])
  @posts = @user.posts
  erb :profile
end

post '/user/update' do
  @user = User.find(session[:user_id]) if session[:user_id]
  @user.update(params[:user])
  flash[:notice] = 'Account updated'
  redirect '/account_setting'
end

post '/user/photo' do
  @user = User.find(session[:user_id]) if session[:user_id]
  @user.update(params[:user])
  flash[:notice] = 'Account updated'
  redirect '/account_setting'
end


