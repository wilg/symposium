class RegistrationController < ApplicationController
  
  before_filter :check_session_student, :except => [:index, :begin, :view_sessions]
  
  def view_sessions
    @lectures = Lecture.find(:all, :include => :category, :order => "lecture_categories.title asc, lectures.title asc", :conditions => "selectable = 1")
    
  end
  
  
  def begin

    if params[:name].blank?
      flash[:warning] = "Nothing is not a name."
      redirect_to :action => "index", :controller => "registration"
      return
    end

    @student = Student.find_by_name(params[:name].to_s)
    
    if @student.nil?
      flash[:warning] = "We don't recognize that name.<br /><br />The name you usually go by should work; however, if it doesn't please try your full first name."
      redirect_to :action => "index", :controller => "registration"
      return
    end
    
    session[:student_id] = @student.id
    
    if @student.lectures.length >= Student.pickable_lectures && !@student.picks.first.sort.nil?
      if GlobalSettings.main.allow_change_mind
        redirect_to :action => "already_completed"
      else
        flash[:warning] = "You've already registered."
        redirect_to :action => "index", :controller => "registration"
      end
    end
        
  end
  
  def pick_again
    student = Student.find(session[:student_id])
    
    student.picks.destroy_all
    
    redirect_to :action => "begin", :name => student.name
    
  end
  
  def logout
    session[:student_id] = nil
    redirect_to :action => "index"
  end
  
  def pick_sessions
    student = Student.find(session[:student_id])
    
    @lectures = Lecture.find(:all, :include => :category, :order => "lecture_categories.title asc, lectures.title asc", :conditions => "selectable = 1")
    @lectures = @lectures.reject{|x| !x.available_for_grade(student.grade)}
    
    if params[:lectures]
      if params[:lectures].length == Student.pickable_lectures
        
        student.picks.destroy_all
        for lecture in params[:lectures]          
          student.lectures << Lecture.find(lecture)
        end
        
        redirect_to :action => "order_sessions"
        
      else
        flash[:warning] = "You need to pick #{Student.pickable_lectures} breakout sessions."
      end
    end
    
  end
  
  def order_sessions
        
    if params[:ordered_lectures]
      
      student = Student.find(session[:student_id])
      
      params[:ordered_lectures].each_key {|key|
        pick = Pick.find(:first, :conditions => ["student_id = ? and lecture_id = ?", student.id, key.to_s])
        pick.sort = params[:ordered_lectures][key]
        pick.save
      }
      
      redirect_to :action => "review"
    end
    
    @lectures = Student.find(session[:student_id]).lectures.find(:all, :order => "picks.sort asc")
    
    
  end
  
  def review
    @lectures = Student.find(session[:student_id]).lectures.find(:all, :order => "picks.sort asc")
    
    
  end
  
  def already_completed
    @student = Student.find(session[:student_id])
    
    @lectures = Student.find(session[:student_id]).lectures.find(:all, :order => "picks.sort asc")
    
    
  end
  
  
  def review_done
    session[:student_id] = nil
    flash[:notice] = "Thanks for playing!"
    redirect_to "/"
  end
  
  private
  
  def check_session_student
    
    if session[:student_id]
      @student = Student.find(session[:student_id])
    else
      redirect_to :action => "index"
    end
    
  end
  
end
