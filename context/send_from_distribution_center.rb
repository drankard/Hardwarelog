require File.dirname(__FILE__) + "/../model/hardware"
require File.dirname(__FILE__) + "/../model/distribu"
require File.dirname(__FILE__) + "/../model/customer"


require File.dirname(__FILE__) + "/../roles/sender"
require File.dirname(__FILE__) + "/../roles/receiver"
require File.dirname(__FILE__) + "/../repository/couch_repository"

class SendFromDistributionCenter
  include CouchRepository 
  
  def initialize(serialnumber, customer_key)
    @hw = Hardware.new(serialnumber)
    
    @distribu = Distribu.new
    @distribu.extend Sender
    
    @customer = Customer.new(customer_key)
    @customer.extend Receiver
    
  end
  
  def send 
    log = Array.new 
    log << "direct order completion"
    log << @distribu.send(@hw)
    log << @customer.receives(@hw)
    persist(@customer, @hw, log)
  end 
  
end   

DB = "http://localhost:5984/hwlog"
a = SendFromDistributionCenter.new('ABC-123', '12344556678')
a.send