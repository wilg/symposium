class CreateTimeblocks < ActiveRecord::Migration
  def self.up
    create_table :timeblocks do |t|
      t.column :length, :integer
      t.column :order, :integer
      
      t.column :name, :string
      
      t.timestamps
    end
  end

  def self.down
    drop_table :timeblocks
  end
end
