require File.dirname(__FILE__) + "/../model/hardware"
require File.dirname(__FILE__) + "/../model/distribu"
require File.dirname(__FILE__) + "/../model/carrier"
require File.dirname(__FILE__) + "/../model/salesagent"


require File.dirname(__FILE__) + "/../roles/delivere"
require File.dirname(__FILE__) + "/../roles/receiver"

require File.dirname(__FILE__) + "/../repository/couch_repository"

class SalesagentReceivesFromCarrier
  include CouchRepository
  
  def initialize(serialnumber,  salesagent_code) 

    

    @hw = Hardware.new(serialnumber)
    @carrier = Carrier.new
    @carrier.extend Delivere
      
    @salesagent = Salesagent.new(salesagent_code)
    @salesagent.extend Receiver
  end
                                 
  def receive
    log = Array.new
    log << "Receipt"
    log << @carrier.hand_over(@hw)
    log << @salesagent.receives(@hw)
    persist(@salesagent, @hw, log)  
  end
  
end    
 

DB = "http://localhost:5984/hwlog"
a = SalesagentReceivesFromCarrier.new('ABC-123', 'T2030')
a.receive