class GradeExclusive < ActiveRecord::Migration
  def self.up
    add_column :lectures, :only_grades, :string
  end

  def self.down
    remove_column :lectures, :only_grades
  end
end
