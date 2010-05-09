require 'rubygems'
require 'sinatra'      
require 'rack'
require File.dirname(__FILE__) + "/../repository/couch_repository"  


DB = "http://localhost:5984/hwlog"

configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end

get '/' do
  content_type 'text/html', :charset => 'utf-8'  
  erb :index   
end  

get '/sn/:sn' do
   extend CouchRepository
   content_type 'text/html', :charset => 'utf-8'
   @hw = get_hardware(params[:sn])
   erb :view_hardware
end

