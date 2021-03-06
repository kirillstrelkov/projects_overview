# frozen_string_literal: true

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'cucumber/rails'
require 'capybara/poltergeist'

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

$browser = ENV['BROWSER'] || :chrome
$browser = $browser.to_sym

$driver = ENV['DRIVER'] || :selenium_chrome_headless
$driver = $driver.to_sym

puts "Driver: #{$driver}"
puts "Browser: #{$browser}" if $driver == :selenium

Capybara.default_driver = $driver

Capybara.register_driver :selenium do |app|
  if $browser == :chrome
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
      'chromeOptions' => {
        'args' => ['start-maximized', '--disable-notifications']
      }
    )
    Capybara::Selenium::Driver.new(
      app, browser: $browser, desired_capabilities: caps
    )
  else
    Capybara::Selenium::Driver.new(app, browser: $browser)
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app, cookies: true, window_size: [1366, 768]
  )
end

mobile_drivers_and_names = {
  iphone6: 'Apple iPhone 6',
  s4: 'Samsung Galaxy S4'
}
$mobile_drivers = mobile_drivers_and_names.keys
mobile_drivers_and_names.each do |device_symbol, device_name|
  Capybara.register_driver device_symbol do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      'chromeOptions' => {
        'mobileEmulation' => { 'deviceName' => device_name }
      }
    )
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities
    )
  end
end

Capybara.app_host = 'http://localhost'
Capybara.always_include_port = true
Capybara.server_port = 31_337
