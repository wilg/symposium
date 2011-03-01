class Timeblock < ActiveRecord::Base
  
  has_many :sections, :dependent => :destroy
    
  def self.time_ordered
    Timeblock.find(:all, :order => "`order` asc, id asc")
  end
  
  def self.daybreak
    Time.parse("08:00 AM") 
  end
  
  def self.padding
    5
  end
  
  def start_time
    if self.length.blank? || self.order.blank?
      return nil
    end
    timestamps = Timeblock.find(:all, :order => "`order` asc, id asc").reject{|x| x.length.blank? || x.order.blank?}
    the_time = Timeblock.daybreak
    for ts in timestamps
      if ts.id == self.id
        break
      end
      the_time = the_time.advance(:minutes => Timeblock.padding)
      the_time = the_time.advance(:minutes => ts.length)
    end
    the_time
  end
  
  def end_time
    time = self.start_time
    if not time.nil?
      time.advance(:minutes => self.length)
    else
      nil
    end
  end
  
  
end
