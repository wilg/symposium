class GlobalSettings < ActiveRecord::Base
    
  def self.main
    x = GlobalSettings.find(:first)
    if x.nil?
      x = GlobalSettings.new()
      x.save
    end
    x
  end
  
end
