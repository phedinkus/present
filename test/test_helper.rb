# App setup stuff
ENV['PRESENT_ADMIN_GITHUB_IDS'] = "doubot"

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
Capybara.default_driver = ENV['HEADLESS'] ? :poltergeist : :chrome


class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
end
