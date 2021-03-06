# frozen_string_literal: true

class DueDate < ActiveRecord::Base
  default_scope { order('date ASC') }
  validates :name, :date, presence: true
  validates :name, uniqueness: { scope: %i[date project_id] }
  belongs_to :project
end
