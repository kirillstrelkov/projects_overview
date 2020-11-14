# frozen_string_literal: true

Then(/^I should see popover$/) do
  expect(page).to have_selector('.popover', visible: true)
end

Then(/^I should see "([^"]*)" in popover$/) do |text|
  within '.popover' do
    assert_text text
  end
end
