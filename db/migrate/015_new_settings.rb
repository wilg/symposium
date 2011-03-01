class NewSettings < ActiveRecord::Migration
  def self.up
    add_column :global_settings, :allow_signup, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :global_settings, :allow_signup
  end
end
