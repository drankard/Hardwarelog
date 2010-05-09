class Carrier < Location
  
  def initialize
    super("Carrier")
  end        
  
  def location_type
      return 3
  end
end