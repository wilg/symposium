class EvenMoreSettins < ActiveRecord::Migration
  def self.up
      add_column :global_settings, :welcome_title, :text, :null => false, :default => "Hello, <strong>%name</strong>!"
      add_column :global_settings, :welcome_text, :text, :null => false, :default => "Think carefully about which topics you would like to learn more about so you can make the most of Symposium."
      add_column :global_settings, :registration_closed, :text, :null => false, :default => "Whoopsie! Symposium registration is now closed. If you didn't already register, you'll be assigned breakout sessions where space is available."
      
      #       add_column :global_settings, :welcome_title, :text, :default => "Hello, %name! How is life as a %grade?<br />Good? Good.", :null => false
      #       add_column :global_settings, :welcome_text, :text, :default => "This year's Symposium is on Energy and Sustainability, and we've busted our hump to make sure that you have some interesting and enlightening sessions to pick from.
      # So please, think carefully about which topics you would like to learn more about so you can make the most of Symposium.", :null => false
      #       add_column :global_settings, :registration_closed, :text, :default => "Whoopsie! Symposium registration is now closed. If you didn't already register, you'll be assigned breakout sessions where space is available.", :null => false
      # 
  end

  def self.down
    remove_column :global_settings, :welcome_title
    remove_column :global_settings, :welcome_text
    remove_column :global_settings, :registration_closed
  end
end
