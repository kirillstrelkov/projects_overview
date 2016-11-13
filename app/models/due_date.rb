class DueDate < ActiveRecord::Base
  default_scope { order('date ASC') }
  validates :name, :date, presence: true
  belongs_to :project
end
