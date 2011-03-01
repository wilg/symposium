class Pick < ActiveRecord::Base
  
  belongs_to :lecture
  belongs_to :student
  
end
