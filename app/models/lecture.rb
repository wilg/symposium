class Lecture < ActiveRecord::Base
  
  has_many :picks, :dependent => :destroy
  has_many :students, :through => :picks
  belongs_to :category, :class_name => "LectureCategory", :foreign_key => "category_id"
  has_many :sections, :dependent => :destroy
  
  
  named_scope :visible, :conditions => {:selectable => true}
  named_scope :invisible, :conditions => {:selectable => false}
  
  named_scope :ordered, {:include => :category, :order => "lecture_categories.title asc, lectures.title asc"}
  
  
  def category_name
    if self.category.nil?
      "---"
    else
      self.category.title
    end
  end
  
  def available_for_grade(grade)
    if self.only_grades.blank?
      return true
    end
    available_grades = self.only_grades.split(",")
    return_value = false
    for grade_string in available_grades
      if grade_string.to_i == grade
        return_value = true
      end
    end
    return_value
  end
  
  def students_signed_up_count(choice = 0)
    if choice == 0
      self.picks.find(:all, :conditions => "sort is not null").length
    else
      self.picks.find(:all, :conditions => ["sort = ?", choice]).length
    end
  end
  
end
