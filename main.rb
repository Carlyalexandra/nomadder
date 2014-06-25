require 'sinatra'
require 'sinatra/activerecord'
require './models'

require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash' 

set :database, "sqlite3:nomdder_app.sqlite3"

get '/' do
  @title = "Welcome to Nomadder"
  erb :sign_in, :layout => false
end