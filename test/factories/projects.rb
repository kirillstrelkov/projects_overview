# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { 'MyString' }
    description { 'MyText' }
    progress { 0.0 }
  end
end
