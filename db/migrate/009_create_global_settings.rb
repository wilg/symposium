class CreateGlobalSettings < ActiveRecord::Migration
  def self.up
    create_table :global_settings do |t|
      t.column :settings, :text
    end
  end

  def self.down
    drop_table :global_settings
  end
end
