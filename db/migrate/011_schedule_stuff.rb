class ScheduleStuff < ActiveRecord::Migration
  def self.up
    add_column :lectures, :selectable, :boolean, :default => true, :null => false
    add_column :timeblocks, :accepts_lecture, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :lectures, :selectable
    remove_column :timeblocks, :accepts_lecture
    
  end
end
