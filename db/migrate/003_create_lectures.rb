class CreateLectures < ActiveRecord::Migration
  def self.up
    create_table :lectures do |t|
      t.column :title, :string
      t.column :presenter, :string
      t.column :description, :text
      
      t.timestamps
    end
  end

  def self.down
    drop_table :lectures
  end
end
