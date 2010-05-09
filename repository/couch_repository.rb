require 'rubygems' 
require 'guid'     
require 'rest_client'
require 'json'
require "cgi"
require 'pp'

require File.dirname(__FILE__) + "/../model/hardware"
require File.dirname(__FILE__) + "/../model/distribu"
require File.dirname(__FILE__) + "/../model/carrier"
require File.dirname(__FILE__) + "/../model/salesagent"

module CouchRepository

  def persist(location, hw, log)

    encoded = CGI.escape("#{hw}")
    url = "#{DB}/#{encoded}"
    
                 
    doc = find_existing_doc(url)
    if doc.empty?                                                      
      doc = Hash.new        
      doc['_id'] = hw.serialnumber 
    end  

    doc['location'] = location.to_s
    doc['location_type'] = location.location_type
    history = rebuild_history(doc, log) 
    doc['history'] = history
                            
    print_doc(doc)
    save(doc, url)
  end  
  
  def print_doc(doc)
    puts "id: #{doc['_id']}"
    puts "location: #{doc['location']}" 
    puts "location_type: #{doc['location_type']}"
    puts "history"
    history = doc['history']
    history.each do | tx |
      unless tx.nil?
        puts "    -------------------------------------------------"
         tx.each do | line | 
          puts "    #{line}"          
         end         
      end 
      
    end
  end 
  
  
  def rebuild_history(doc, log)
    history = doc['history']    
    
    if history.nil?
      history = Array.new
    end           
    
    current = Array.new
    now = Time.now
    stamp = "#{now.day} #{now.mon}" 
    current << Time.now.strftime("%Y-%m-%d %H:%M:%S")
    log.each do | line |
      current << line
    end             
    history << current    
    return history 
  end  
  
  
  def get_hardware(serialnumber)
    encoded = CGI.escape("#{serialnumber}")
    url = "#{DB}/#{encoded}"
    doc = find_existing_doc(url)   
    hw = Hardware.new(doc['_id'])

    location = case doc['location_type']
      when 0 then Distribu.new
      when 1 then Customer.new(doc['location']) 
      when 2 then Salesagent.new(doc['location'])
      when 3 then Carrier.new
    end                   
    hw.location = location 
    hw.history = doc['history']   
    return hw
  end 
         
  
  
  
  private 
              
  def find_existing_doc(url) 
    begin
      data = RestClient.get url     
    rescue
         puts "No doc found"    
    else
      return JSON.parse(data.to_s)      
    end
    return Hash.new
  end 
  
  def save(doc, url)
    data =  RestClient.put url, doc.to_json, :content_type => 'application/json'
    result = JSON.parse(data.to_s)                 
    raise "Unable to put product: #{result['id']} " if result['ok'] = false
    return result    
  end
end                