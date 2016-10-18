class Project < ActiveRecord::Base
  has_many :due_dates
end
