require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Present
  class Application < Rails::Application
    Rails.application.config.present = ActiveSupport::OrderedOptions.new
    Rails.application.config.present.url = "http://present.testdouble.com"
    Rails.application.config.github = ActiveSupport::OrderedOptions.new
    Rails.application.config.github.client_id = ENV['PRESENT_GITHUB_CLIENT_ID']
  end
end
