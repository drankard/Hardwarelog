require 'rubygems'
require 'sinatra'      
require 'rack'
require File.dirname(__FILE__) + "/../repository/couch_repository"  
require File.dirname(__FILE__) + "/../context/send_from_distribution_center"


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

get '/send_from_distribu/sn/:sn/customer/:customer_key' do
    extend CouchRepository   
    content_type 'text/html', :charset => 'utf-8'
    
    sn = params[:sn]
    customer_key = params[:customer_key]
    puts sn
    puts customer_key
    a = SendFromDistributionCenter.new(sn, customer_key)
    a.send  
    redirect '/sn/' + sn
end

