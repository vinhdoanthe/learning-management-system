require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module TEKYLMS
  class Application < Rails::Application
    config.generators do |g|
      g.orm :active_record
    end
    config.load_defaults 6.0
    config.active_storage.replace_on_assign_to_many = false
    config.time_zone = 'Asia/Ho_Chi_Minh'
  end
end
