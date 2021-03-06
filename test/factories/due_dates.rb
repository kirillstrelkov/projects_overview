# frozen_string_literal: true

FactoryBot.define do
  factory :due_date do
    name { 'MyString' }
    description { 'MyString' }
    date { '2016-10-18 23:35:03' }
    progress { 1.5 }
    project_id { 1 }
  end
end
