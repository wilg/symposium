class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string
      t.column :capacity, :integer, :default => 50
    end
  end

  def self.down
    drop_table :groups
  end
end
