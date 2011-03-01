class Student < ActiveRecord::Base
  
  has_many :picks, :dependent => :destroy
  belongs_to :group
  has_many :lectures, :through => :picks
  
  
  def self.pickable_lectures
    return 4
  end
  
  def self.have_registered
    Student.find(:all, :include => :picks).reject{|x| !x.has_registered?}
  end
  
  def self.have_not_registered
    Student.find(:all, :include => :picks).reject{|x| x.picks.length > 0}
  end
  
  def has_registered?
    if self.picks.length > 0 && !self.picks.first.sort.nil?
      true
    else
      false
    end
  end
  
  def self.add_students_from_file(upload)
    text = upload.read
    text.gsub! "\r\n", "\n" # DOS
    text.gsub! "\r", "\n" # Mac
    # text.encoding(Encoding.find("UTF-8"))
    # text = text.toutf8
    #text = Iconv.conv('utf-8', 'ISO-8859-1', text)
    
    filename = upload.original_filename

    if filename.include?(".csv")
      delimiter = ","
    elsif filename.include?(".txt")
      delimiter = "\t"
    else
      return false
    end
    
    number_imported = 0
    text.chars.each_line{ |line|
      # raise line
      
      splits = line.strip.chars.split(delimiter)
      
      if splits.length >= 2
        student = Student.new()
        # last_name = splits[1].to_s
        # first_name = splits[2].to_s

        student.name = splits[1].to_s.strip
        student.grade = splits[0].to_s.strip.to_i
        if student.save
          number_imported = number_imported + 1
        end
      end
      
    }
    
    number_imported
  end
  
  def text_grade
    case self.grade
    when 9
      "Freshman"
    when 10
      "Sophomore"
    when 11
      "Junior"
    when 12
      "Senior"
    end
  end
  
  def group_quality
    did_not_choose = 15
    got_the_shaft = 20
    
    group = self.group
    lids = group.lecture_ids
    picks = self.picks.find(:all, :order => "sort asc")
    
    if picks.length == 0 || picks.first.sort.nil?
      return did_not_choose
    end
    
    for pick in picks
      if lids.include?(pick.lecture_id)
        return pick.sort
        break
      end
    end
    
    return got_the_shaft
  end
  
  def lecture_in_schedule?(lecture)
    if self.group.lecture_ids.include?(lecture.id)
      true
    else
      false
    end
  end
  
end
