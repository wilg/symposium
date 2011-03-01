class PickOrder < ActiveRecord::Migration
  def self.up
    add_column :students_lectures, :pick_order, :integer
    
  end

  def self.down
    remove_column :students_lectures, :pick_order
    
  end
end
