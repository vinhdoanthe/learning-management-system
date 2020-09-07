# require 'lograge/sql/extension'

Rails.application.configure do
  # Lograge config
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.colorize_logging = false

  # config.lograge.ignore_actions = ['ActiveStorage::BlobsController#show', 'ActiveStorage::RepresentationsController#show', 'ActiveStorage::DiskController#show', 'ActiveStorage::DiskController#update', 'ActiveStorage::DirectUploadsController#create']

  # config.lograge.custom_payload do |controller|
  #   {
  #     host: controller.request.host,
  #     user_id: controller.current_user.try(:id)
  #   }
  # end

  config.lograge.custom_options = lambda do |event|
    { :params => event.payload[:params] }
  end
end
