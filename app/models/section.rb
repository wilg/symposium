class Section < ActiveRecord::Base
  
  belongs_to :lecture
  belongs_to :timeblock
  belongs_to :group
  
  def self.t_g(timeblock, group)
     Section.find(:all, :limit => 1, :conditions => ["timeblock_id = ? and group_id = ?", timeblock.id, group.id]).first
  end
  
  
end
