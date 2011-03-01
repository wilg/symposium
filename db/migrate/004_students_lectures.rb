class StudentsLectures < ActiveRecord::Migration
  def self.up
    create_table :students_lectures do |t|
      t.column :student_id, :integer
      t.column :lecture_id, :integer
    end
  end

  def self.down
    drop_table :students_lectures
  end
end
