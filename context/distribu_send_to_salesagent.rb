require File.dirname(__FILE__) + "/../model/hardware"
require File.dirname(__FILE__) + "/../model/distribu"
require File.dirname(__FILE__) + "/../model/carrier"
require File.dirname(__FILE__) + "/../model/salesagent"


require File.dirname(__FILE__) + "/../roles/sender"
require File.dirname(__FILE__) + "/../roles/receiver" 

require File.dirname(__FILE__) + "/../repository/couch_repository"  

class DistribuSendToSalesagent
  include CouchRepository
  
  
  def initialize(serialnumber, salesagent_code)
    @hw = Hardware.new(serialnumber)
    @distribu = Distribu.new
    @distribu.extend Sender
    
    @carrier = Carrier.new
    @carrier.extend Receiver
    
    @salesagent = Salesagent.new(salesagent_code) 
  end
  
  def send
    log = Array.new  
    log << "Transit to salesagent"
    log << @distribu.send(@hw)
    log << @carrier.receives(@hw)
    persist(@salesagent, @hw, log)
  end
  
end

DB = "http://localhost:5984/hwlog" 
a = DistribuSendToSalesagent.new('ABC-123', 'T6556') 
a.send