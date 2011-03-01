class CreatePicks < ActiveRecord::Migration
  def self.up
    create_table :picks do |t|
      t.column :student_id, :integer
      t.column :lecture_id, :integer
      t.column :sort, :integer
    end
    drop_table :students_lectures
    
  end

  def self.down
    drop_table :picks
  end
end
