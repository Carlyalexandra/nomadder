require 'sinatra'
require 'sinatra/activerecord'
require './models'

require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash' 

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true
set :database, "sqlite3:nomdder_app.sqlite3"

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
  @user = User.where(params[:user])
  if @user.empty?
    flash[:alert] = "Sorry, that user doesn't exist. Feel free to sign up."
    # session[:user_id] = @user.first.id
    redirect '/'
  else
    flash[:notice] = "You've successfully signed in."
    redirect '/logged_in'
  end
end

get '/sign_out' do
   session[:user_id] = nil
   redirect '/'
end

get '/logged_in' do
  @title = "Welcome to Nomadder"
  erb :logged_in
end

