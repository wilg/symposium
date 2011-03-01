class MoreSettings < ActiveRecord::Migration
  def self.up
    add_column :global_settings, :allow_change_mind, :boolean, :default => true, :null => false
    add_column :global_settings, :show_categories, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :global_settings, :allow_change_mind
    remove_column :global_settings, :show_categories
  end
end
