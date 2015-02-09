Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.raise_runtime_errors = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  if ENV['PROFILE']
    config.after_initialize do
      Bullet.enable = true
      Bullet.console = true
      Bullet.rails_logger = true
      Bullet.add_footer = true
    end
  end
end
