# frozen_string_literal: true

Given(/^I am on "([^"]*)"$/) do |url|
  visit(url)
end

Given(/^I am on main page$/) do
  visit('/')
end

Given(/^I am on "([^"]*)" page$/) do |path|
  visit(path)
end

When(/^I click "([^"]*)"$/) do |locator|
  click_link_or_button(locator)
end

Then(/^I should be on "([^"]*)"$/) do |url|
  wait_for(Capybara.default_max_wait_time) { expect(URI.parse(current_url).path).to eq(url) }
end

Then(/^I should be on "([^"]*)" within (\d+|\d+\.\d+) seconds?$/) do |url, timeout|
  wait_for(timeout.to_f) { expect(current_url).to eq(url) }
end

Then(/^I should see "([^"]*)" within (\d+) seconds$/) do |text, timeout|
  assert_text(text, wait: timeout.to_f)
end

Then(/^I should see "([^"]*)" on page$/) do |expected_text|
  wait_for do
    input_values = all('input,textarea', visible: true).map(&:value).join(' ')
    text = "#{page.text} #{input_values}"
    expect(text).to include(expected_text)
  end
end

Then(/^I should see "([^"]*)" before "([^"]*)" on page$/) do |text1, text2|
  wait_for do
    input_values = all('input,textarea', visible: true).map(&:value).join(' ')
    text = "#{page.text} #{input_values}"
    expect(text.index(text1)).to be < text.index(text2), "'#{text1}' should be before '#{text2}'"
  end
end

Then(/^I should not see "([^"]*)" on page$/) do |not_expected_text|
  wait_for do
    input_values = all('input', visible: true).map(&:value).join(' ')
    text = "#{page.text} #{input_values}"
    expect(text).not_to include(not_expected_text)
  end
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |locator, text|
  fill_in(locator, with: text)
end

When(/^I fill in css element "([^"]*)" with "([^"]*)"$/) do |locator, text|
  find(:css, locator).set(text)
end

When(/^I click css element "([^"]*)"$/) do |locator|
  find(:css, locator).click
end

And(/^I select "([^"]*)" from "([^"]*)"$/) do |text, locator|
  sleep(0.3) if Capybara.current_driver == :poltergeist
  if first('.selectpicker')
    3.times do |_|
      find("button[data-id='#{locator}']").click
      break if has_css?('.dropdown-menu.open')
    end
    find('.dropdown-menu.open').find('a span.text', text: text).click
  else
    select(text, from: locator, visible: false)
  end
end

Then(/^I should see "([^"]*)" option selected in "([^"]*)"$/) do |text, locator|
  if first('.selectpicker')
    expect(find("button[data-id='#{locator}']")['title']).to eq(text)
  else
    expect(page).to have_select(locator, selected: text, visible: false)
  end
end

When(/^I wait for (\d+\.\d+|\d+) seconds?$/) do |timeout|
  sleep(timeout.to_f)
end

When(/^I accept alert$/) do
  accept_alert
end

When(/^I cancel alert$/) do
  accept_alert { click_button('Cancel') }
end

Then(/^I refresh page$/) do
  visit(current_url)
end

When(/^I debug$/) do
  byebug
end

Given(/^pending.*$/) do
  pending
end

When(/^I hit (\w+) in "([^"]*)"$/) do |key, locator|
  find(:fillable_field, locator).native.send_keys(key.downcase.to_sym)
end

When(/^I clear browser$/) do
  reset_session!
end
