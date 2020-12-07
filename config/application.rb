require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)


module TEKYLMS
  class Application < Rails::Application
    config.generators do |g|
      g.orm :active_record
    end
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.active_storage.replace_on_assign_to_many = false
    ActiveRecord::SessionStore::Session.primary_key = 'session_id'
    config.time_zone = 'Asia/Ho_Chi_Minh'
    config.filter_parameters << :password
    Raven.configure do |config|
      config.dsn = Settings.sentry_raven_dsn
      # config.environments = %w[ production ]
      config.excluded_exceptions += ['ActiveStorage::FileNotFoundError']
    end
  end
end
