class CreateGroupLectures < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.column :lecture_id, :integer
      t.column :group_id, :integer
      t.column :timeblock_id, :integer
    end
    add_column :students, :group_id, :integer
  end

  def self.down
    remove_column :students, :group_id
    drop_table :sections
  end
end
