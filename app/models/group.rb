class Group < ActiveRecord::Base
  
  has_many :students
  has_many :sections
  # has_many :timeblocks, :through => :group_lectures
  has_many :lectures, :through => :sections
  
  def grade_restriction
    restriction = ""
    restricted_sessions = self.lectures.find(:all, :conditions => "only_grades is not null").reject{ |x| x.only_grades.blank? }
    if restricted_sessions.length == 1
      restriction =  restricted_sessions.first.only_grades
    elsif restricted_sessions.length > 1
      grades = nil
      for session in restricted_sessions
        if grades == nil
          grades = session.only_grades
        else
          grades << "," << session.only_grades
        end
      end
      restriction =  grades
    else
      return nil
    end
    rarray = restriction.split(",").uniq
    return rarray.each_index{|index| rarray[index] = rarray[index].to_i}.sort
  end
  
  def appropriate_for_grade?(student)
    restriction = self.grade_restriction
    if not restriction.nil?
      if restriction.include?(student.grade.to_i)
        true
      else
        false
      end
    else
      true
    end
  end
  
  def full?
    if self.students.count(:all) >= self.capacity
      true
    else
      false
    end
  end
  
  # http://localhost:3002/admin/autofill?sure=sure
  def self.autofill
    if GlobalSettings.main.autofill_in_progress == true
      return
    end
    
    settings = GlobalSettings.main
    settings.autofill_in_progress = true
    settings.save

    Group.clear_students
    ungrouped_students = Student.find(:all, :include => :picks) #:conditions => "students.group_id is null"
    available_groups = Group.find(:all, :include => [:lectures, :sections], :order => "lectures.only_grades desc, groups.id asc")
    
    unregistered_students = []
    
    for student in ungrouped_students
      student_picks = student.picks.find(:all, :order => "sort asc")
      if student_picks.length == 0 || student_picks.first.sort.nil?
        unregistered_students << student
        next
      end
      # make sure the group accepts their grade
      my_groups = available_groups.reject{ |group| !group.appropriate_for_grade?(student) }
      # make sure that group isn't full
      my_groups = my_groups.reject{ |group| group.full? }
      
      for pick in student_picks
        if !student.group.nil? then break end
        for group in my_groups
          if !student.group.nil? then break end
          lecture_ids = group.lecture_ids
          if lecture_ids.include?(pick.lecture_id)
            #success! we've found this choice
            # raise "Found it! Placing in #{group.name} for student named #{student.name}"
            student.group = group
            student.save!
            break
          end
        end
      end
    end
    
    #assholes who didn't register
    for student in unregistered_students
      my_groups = available_groups.reject{ |group| !group.appropriate_for_grade?(student) }
      my_groups = my_groups.reject{ |group| group.full? }
      student.group = my_groups.first
      student.save!
    end
    
    settings.autofill_in_progress = false
    settings.save
  end
  
  def self.clear_students
    for group in Group.find(:all)
      group.students = []
    end
  end
  
  def self.total_capacity
    total = 0
    for group in Group.find(:all)
      total += group.capacity
    end
    total
  end
  
end
