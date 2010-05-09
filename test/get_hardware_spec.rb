require File.dirname(__FILE__) + "/../repository/couch_repository"

DB = "http://localhost:5984/hwlog"
include CouchRepository 


describe "Yesyer" do
  it "should lsls" do
    hw = get_hardware('ABC-123')  
    hw.should != nil
  end
end             
    
   
