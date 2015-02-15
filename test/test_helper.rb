ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/pride"
require 'minitest/given'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
end
