require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'valid' do
    project = FactoryGirl.build(:project)
    expect(project).to be_valid
  end
  it 'invalid' do
    project = FactoryGirl.build(:project, name: nil)
    expect(project).not_to be_valid
  end
  it 'default progress' do
    project = Project.new(name: 'name')
    project.save!
    expect(project.progress).to eq(0.0)
  end
end
