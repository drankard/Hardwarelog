require File.dirname(__FILE__) + "/location"

class Salesagent < Location
  def initialize(salesagent_code)
    super(salesagent_code)
  end                              

  def location_type
    return 2
  end  
                 
end         
