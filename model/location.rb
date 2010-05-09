class Location
  def initialize(location_name)
    @location_name = location_name
  end
  attr_reader :location_name
  
  def to_s
    return @location_name
  end
end