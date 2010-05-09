class Hardware
  def initialize(serialnumber)
     @serialnumber = serialnumber
  end                              
  attr_reader :serialnumber
  attr_accessor :location 
  attr_accessor :history
  
  
  def to_s
     return @serialnumber
  end
end                         