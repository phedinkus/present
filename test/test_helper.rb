#Rails stuff
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

#Minitest stuff
require "minitest/rails"
require "minitest/pride"
require 'minitest/given'

#Capybara stuff
require "minitest/rails/capybara"
require 'capybara/poltergeist'
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :js_errors => false)
end
Capybara.default_driver = ENV['HEADLESS'] ? :poltergeist : :chrome
Capybara.server_port = ENV['PRESENT_TEST_PORT']

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
end
