require File.dirname(__FILE__) + "/../model/hardware"
require File.dirname(__FILE__) + "/../model/salesagent"
require File.dirname(__FILE__) + "/../model/customer"


require File.dirname(__FILE__) + "/../roles/delivere"
require File.dirname(__FILE__) + "/../roles/receiver"
require File.dirname(__FILE__) + "/../repository/couch_repository"

class SalesagentSale   
  include CouchRepository 
  
  def initialize(serialnumber, salesagent_code, customer_key)
    @hw = Hardware.new(serialnumber) 
    
    @salesagent = Salesagent.new(salesagent_code) 
    @salesagent.extend Delivere
    
    @customer = Customer.new(customer_key)
    @customer.extend Receiver            
    
  end  
  
  def perform_sale               
    log = Array.new                  
    log << "Salesagent sale"
    log << @salesagent.hand_over(@hw)
    log << @customer.receives(@hw) 
    persist(@customer, @hw, log)
  end
end

                     


