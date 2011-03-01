class CreateLectureCategories < ActiveRecord::Migration
  def self.up
    create_table :lecture_categories do |t|
      t.column :title, :string
      
    end
    
    add_column :lectures, :category_id, :integer
    
  end

  def self.down
    remove_column :lectures, :category_id
    
    drop_table :lecture_categories
  end
end
