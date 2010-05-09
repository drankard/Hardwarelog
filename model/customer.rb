require File.dirname(__FILE__) + "/location"

class Customer < Location

  def initialize(customer_key)
    super(customer_key)
  end                              

  def location_type
    return 1
  end
end