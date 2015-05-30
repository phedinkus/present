# Coverage stuff
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

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

# ensure only one AR connection so we can use transactional fixtures
# https://gist.github.com/josevalim/470808
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
end
