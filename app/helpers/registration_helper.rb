module RegistrationHelper
  
  def settings_text_format(text)
    if @student
      student_name = @student.name
      student_grade = @student.text_grade.downcase
    end
    text.sub!("%name", student_name)
    text.sub!("%grade", student_grade)
    simple_format(text)
  end
  
end
