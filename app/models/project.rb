# frozen_string_literal: true

class Project < ActiveRecord::Base
  has_many :due_dates, dependent: :destroy
  validates :name, presence: true
  accepts_nested_attributes_for :due_dates, allow_destroy: true
end
