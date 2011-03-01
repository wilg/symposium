class Classroom < ActiveRecord::Migration
  def self.up
    add_column :lectures, :room, :string
  end

  def self.down
    remove_column :lectures, :room
  end
end
