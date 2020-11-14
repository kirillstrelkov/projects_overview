# frozen_string_literal: true

Then(/^I should see calendar$/) do
  wait_for_visible('.bootstrap-datetimepicker-widget')
end

Given(/^current date is "([^"]*)"$/) do |datetime|
  visit("/?current_datetime=#{datetime}")
end

Given(/^there is a project "([^"]*)" with (\d+\.\d+) progress and due dates:$/) do |name, progress, table|
  project = FactoryGirl.create(:project, name: name, progress: progress.to_f)
  data = table.raw
  header = data.first
  data[1..-1].each do |row|
    hash = Hash[header.zip(row)]
    hash[:project_id] = project.id
    FactoryGirl.create(:due_date, hash)
  end
end

Given(/^there is a project "([^"]*)" with "([^"]*)" description, (\d+\.\d+) progress and due dates:$/) do |name, description, progress, table|
  project = FactoryGirl.create(:project, name: name, description: description, progress: progress.to_f)
  data = table.raw
  header = data.first
  data[1..-1].each do |row|
    hash = Hash[header.zip(row)]
    hash[:project_id] = project.id
    FactoryGirl.create(:due_date, hash)
  end
end

When(/^I am on project edit page$/) do
  visit("/projects/#{Project.first.id}/edit")
end

When(/^I am on project view page$/) do
  visit("/projects/#{Project.first.id}")
end

Then(/^(\w+) progress bar should have width (\d+.?\d+)$/) do |type, width|
  wait_for do
    expect(find(".progress-bar.#{type}")['style'][/\d+\.?\d*/].to_f).to eq(width.to_f)
  end
end
