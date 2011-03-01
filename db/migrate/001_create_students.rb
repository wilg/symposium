class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.column :name, :string
      t.column :grade, :integer
      
      t.timestamps
    end    
  end

  def self.down
    drop_table :students
  end
end
