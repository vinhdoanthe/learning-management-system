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
    config.time_zone = 'Asia/Ho_Chi_Minh'
    config.filter_parameters << :password
    Raven.configure do |config|
      config.dsn = 'https://cd0a4f0f5c2347879badd2965e6ba3df:972441f1488b4f97a035b7b180d63416@o398229.ingest.sentry.io/5253599'
    end
  end
end
