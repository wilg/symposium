class AdminController < ApplicationController
  
  before_filter :admin_login_check, :except => [:index, :login]
  layout :choose_layout, :except => :scheduler
  
  def students_csv
    respond_to do |wants|
      
      wants.csv {
        
        csv = ""
        for student in Student.find(:all, :order => "grade asc, name asc")
          csv << "#{student.grade},#{student.name}\n"
        end
        
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{"students"}.csv\"" 
        
        render :text => csv
        
        return
      }
      
    end
  end
  
  def reset
    if params[:commit]
      if params[:checkbox_1] && params[:checkbox_2] && params[:checkbox_3] && params[:password] == APP_CONFIG["admin_password"]
        flash[:warning] = "You did it."
        
        Student.delete_all
        Group.delete_all
        Lecture.delete_all
        LectureCategory.delete_all
        Pick.delete_all
        Section.delete_all
                
        settings = GlobalSettings.main
        settings.allow_signup = false
        settings.save
        
      else
        flash[:warning] = "I guess you're not sure. Don't pull the trigger!"
        return
      end
    end
  end
  
  
  def print_group_schedule
    if params[:all]
      @groups = Group.find(:all)
    else
      @groups = [Group.find(params[:group])]
    end
    @timeblocks = Timeblock.time_ordered
  end
  
  def print_group_students
    if params[:all]
      @groups = Group.find(:all, :include => :students)
    else
      @groups = [Group.find(params[:group], :include => :students)]
    end
    @groups.reject!{|g| g.students.length == 0}
  end
  
  
  def scheduler    
    @groups = Group.find(:all)
    
    @timeblocks = Timeblock.time_ordered   
  end
  
  def schedule_statistics
    @total_students = Student.count(:all)
    @registered_students = Student.have_registered.length
    @first_choice_students = 0
    @second_choice_students = 0
    @third_choice_students = 0
    @fourth_choice_students = 0
    
    for student in Student.find(:all)
      picks = student.picks
      if student.group
        lids = student.group.lecture_ids
        for pick in picks
          if !pick.sort.nil? && lids.include?(pick.lecture_id)
            case pick.sort 
            when 1
              @first_choice_students += 1
            when 2
              @second_choice_students += 1
            when 3
              @third_choice_students += 1
            when 4
              @fourth_choice_students += 1
            end
          end
        end
      end
    end
    
    render :partial => "schedule_statistics"
  end
  
  def autofill
    call_rake :autofill
  end
  
  def autofill_progress
    hash = {};
    if params[:check_for_redirect]
      hash[:stats] = "#{Student.count(:conditions => "group_id is not null")} students grouped"
      if GlobalSettings.main.autofill_in_progress == false
        hash["redirect_to"] = url_for(:action => "scheduler")
      end
    else
      hash[:stats] = "Starting autofill..."
    end
    render :json => hash
  end
  
  def clear_autofill
    if params[:sure]
      Group.clear_students
      flash[:message] = "Autofill cleared."
    end
    redirect_to :action => "scheduler"
  end
  
  def group_students
    @group = Group.find(params[:group])
    @students = @group.students.find(:all, :order => "students.name")
    @students = @students.sort{|x,y| x.group_quality <=> y.group_quality }
  end
  
  
  def scheduler_insert
      render :partial => "scheduler_insert"
  end
  
  def ajax_section_edit
    section = Section.find(params[:section], :include => [:lecture, :group])
    render :partial => "ajax_section_edit", :locals => {:section => section}
  end
  
  def ajax_section_add
    render :partial => "ajax_section_add", :locals => {:lectures => Lecture.find(:all, :order => "title asc")}
  end
  
  def create_section
    if params[:section]
      old = Section.t_g(params[:timeblock], params[:group])
      if not old.nil?
        old.destroy
      end
      
      section = Section.new()
      section.lecture_id = params[:section][:lecture_id]
      section.group_id = params[:group]
      section.timeblock_id = params[:timeblock]
      section.save
      render :partial => "scheduler_insert"
    end
  end
  
  def clear_section
    if params[:section]
      old = Section.find(params[:section])
      old.destroy
    end
    redirect_to :action => "scheduler"
  end
  
  def destroy_student
    @student = Student.find(params[:student])
    if params[:do_it]
      @student.destroy
      redirect_to :action => :students
    end
  end
  
  def timeblocks
        
    if params[:commit]
      params[:timeblocks].each_key {|key|
        this_block = Timeblock.find(key)
        this_block.length = params[:timeblocks][key][:length]
        this_block.name = params[:timeblocks][key][:name]
        this_block.order = params[:timeblocks][key][:order]
        this_block.accepts_lecture = params[:timeblocks][key][:accepts_lecture]
        this_block.save
        flash[:message] = "Timeblocks saved!"
      }
    end
    
    @timeblocks = Timeblock.time_ordered
    
    
  end
  
  def new_timeblock
    t = Timeblock.new(:name => "?")
    t.save
  
    redirect_to :action => "timeblocks"
  end
  
  def delete_timeblock
    t = Timeblock.find(params[:id])
    t.destroy
  
    redirect_to :action => "timeblocks"
  end
  
  def delete_group
    t = Group.find(params[:id])
    t.destroy
  
    redirect_to :action => "groups"
  end
  
  def groups
        
    if params[:commit]
      params[:groups].each_key {|key|
        this_group = Group.find(key)
        this_group.capacity = params[:groups][key][:capacity]
        this_group.name = params[:groups][key][:name]
        this_group.save
        flash[:message] = "Groups saved!"
      }
    end
    
    @groups = Group.find(:all)
    
    
  end
  
  def new_group
    g = Group.new(:name => "New Group")
    g.save
  
    redirect_to :action => "groups"
  end
  
  
  def index
    if session[:admin_logged_in]
      redirect_to :action => "panel", :controller => "admin"
    end
    
  end
  
  def login
    if params[:password] == APP_CONFIG["admin_password"]
      session[:admin_logged_in] = true
      redirect_to :action => "panel", :controller => "admin"
    else
      flash[:notice] = "Wrong password!"
      redirect_to :action => "index", :controller => "admin"
    end
    
  end
  
  def logout
     session[:admin_logged_in] = nil
     flash[:notice] = "You're logged out!"
     redirect_to "/"
  end
  
  def settings
    s = GlobalSettings.main
    if params[:commit]
      
      params[:allow_change_mind] ? s.allow_change_mind = true : s.allow_change_mind = false
      params[:show_categories] ? s.show_categories = true : s.show_categories = false
      params[:allow_signup] ? s.allow_signup = true : s.allow_signup = false
      s.registration_closed = params[:registration_closed]
      s.welcome_text = params[:welcome_text]
      s.welcome_title = params[:welcome_title]
      
      s.save
      flash[:message] = "Settings saved!"
    end
    @settings = s
  end
  
  def categories
    @categories = LectureCategory.find(:all)
  end
  
  def new_category
    c = LectureCategory.new(:title => params[:title])
    c.save
    
    redirect_to :action =>"categories"
  end
  
  def delete_category
    c = LectureCategory.find(params[:cid])
    c.destroy
    
    redirect_to :action =>"categories"
  end
  
  
  def lectures
    
      @normal_lectures = Lecture.find(:all, :include => :category, :order => "lecture_categories.title asc, lectures.title asc", :conditions => "selectable = 1")
      @special_lectures = Lecture.find(:all, :include => :category, :order => "lecture_categories.title asc, lectures.title asc", :conditions => "selectable = 0")
      
  
  end
  
  def lecture_students
    @lecture = Lecture.find(params[:lid])
    @students = @lecture.students.find(:all, :order => "picks.sort asc, students.name")
  
  end
  
  def new_lecture
    l = Lecture.new(:title => "New Lecture")
    l.save
  
    redirect_to :action => "edit_lecture", :lid => l.id
  end
  
  def edit_lecture
    @lecture = Lecture.find(params[:lid])
    
    if params[:lecture]
      @lecture.update_attributes(params[:lecture])
      @lecture.save
      
      flash[:message] = "Lecture saved!"
    end
    
  end
  
  def delete_lecture
    if params[:lid]
      l =  Lecture.find(params[:lid])
      l.destroy
      redirect_to :action => :lectures
    end
    
  end
  
  def students
    conditions_list = []
    
    if not params[:grade].blank?
      conditions_list << "grade = '#{params[:grade]}'"
    end
    if !params[:name].blank?
      conditions_list << "name LIKE '%#{params[:name]}%'"
    end
    
    condition_string = ""
    first = true
    for condition in conditions_list
      if not first
        condition_string << " and " + condition
      else
        condition_string << condition
      end
      first = false
    end
    
    
    if params[:collection] == "have_registered"
      @students = Student.have_registered
      
    elsif params[:collection] == "have_not_registered"
      @students = Student.have_not_registered
      
    else
      @students = Student.find(:all, :order => params[:sort], :conditions => condition_string)
    end
    
  end
  
  def edit_student
    @student = Student.find(params[:sid])
    
    if @student.has_registered?
      @lectures = @student.lectures.find(:all, :order => "picks.sort asc")
    end
    
    if params[:student]
      @student.update_attributes(params[:student])
      @student.save
      
      flash[:message] = "Changes saved!"
    end
    
  end
  
  def clear_selections
    student = Student.find(params[:sid])
    student.picks.destroy_all
    redirect_to :action => "edit_student", :sid => student.id
  end
  
  def import
    if params[:commit]
      if !params[:upload].blank?
        number_imported = Student.add_students_from_file(params[:upload])
        flash[:notice] = "#{number_imported} students imported"
        redirect_to :action => "panel"
        return
      else
        flash[:warning] = "An error!"
      end
    end
  end
  
  
  private

  def choose_layout    
    if ["print_group_schedule", "print_group_students"].include?(action_name)
      "print"
    else
      "application"
    end
  end
  
  
  def admin_login_check
    
    if not session[:admin_logged_in]
      redirect_to :action => "index", :controller => "admin"
    end
    
  end
    
  
end
