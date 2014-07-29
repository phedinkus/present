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
    config.present = ActiveSupport::OrderedOptions.new
    config.present.url = "http://present.testdouble.com"

    config.github = ActiveSupport::OrderedOptions.new
    config.github.client_id = ENV['PRESENT_GITHUB_CLIENT_ID']

    config.harvest = ActiveSupport::OrderedOptions.new
    config.harvest.subdomain = "testdouble"
    config.harvest.username = ENV['PRESENT_HARVEST_USERNAME']
  end
end
