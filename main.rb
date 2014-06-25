require 'sinatra'
require 'sinatra/activerecord'
require './models'

require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash' 

set :database, "sqlite3:nomdder_app.sqlite3"