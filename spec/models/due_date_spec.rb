require 'rails_helper'

RSpec.describe DueDate, type: :model do
  it 'valid' do
    user = FactoryGirl.build(:due_date)
    expect(user).to be_valid
  end
  context 'invalid' do
    it 'has no date' do
      user = FactoryGirl.build(:due_date, date: nil)
      expect(user).not_to be_valid
    end

    it 'has no name' do
      user = FactoryGirl.build(:due_date, name: nil)
      expect(user).not_to be_valid
    end
  end
end
