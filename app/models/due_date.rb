class DueDate < ActiveRecord::Base
  default_scope { order('date ASC') }
  belongs_to :project
end
