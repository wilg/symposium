# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def header_link
    if controller.controller_name == "admin" && session[:admin_logged_in]
      url_for(:action => :panel, :controller => "admin")
    else
      "/"
    end
  end
  
  def add_dependencies(options)
    if not options[:css].blank?
      if @additional_stylesheets
          @additional_stylesheets << options[:css]
      else
        @additional_stylesheets = options[:css].to_a
      end
      @additional_stylesheets.flatten!
      @additional_stylesheets.uniq!
    end
    
    if not options[:js].blank?
      if @additional_javascripts
        @additional_javascripts << options[:js]
      else
        @additional_javascripts = options[:js].to_a
      end
      @additional_javascripts.flatten!
      @additional_javascripts.uniq!
    end
  end
  
  def page_title_with_h1(title)
    page_title title
    "<h1>" + title + "</h1>"
  end
  
  def page_title(title)
    @page_title = title
  end
  
  def get_page_title
    if @page_title
      prefix @page_title
    else
      nil
    end
  end
  
  def prefix(x)
    ENV["RAILS_ENV"] == "production" ? "#{APP_CONFIG["organization_name"]} | #{x}" : "#{APP_CONFIG["organization_name"]} Dev | #{x}"
  end
  
  def devmode?
    ENV["RAILS_ENV"] == "production" ? false : true
  end
  
  def pretty_time(time)
    if not time.blank?
      time.strftime("%l:%M").downcase
    else
      "unknown"
    end
  end
  
  def autofill_completed?
    for group in Group.find(:all)
      if group.students.size > 0
        return true
      end
    end
    return false
  end
  
end
