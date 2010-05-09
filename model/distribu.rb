require File.dirname(__FILE__) + "/location"

class Distribu < Location

  def initialize
    super("DISTRIBU")
  end                              

  def location_type
    return 0
  end
end