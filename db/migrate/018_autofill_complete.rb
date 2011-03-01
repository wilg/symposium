class AutofillComplete < ActiveRecord::Migration
  def self.up
      add_column :global_settings, :autofill_in_progress, :boolean, :default => false
  end

  def self.down
    remove_column :global_settings, :autofill_in_progress
  end
end
