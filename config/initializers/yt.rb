Yt.configure do |config|
  config.client_id = Settings.youtube['client_id']
  config.client_secret = Settings.youtube['client_secret']
  config.api_key = Settings.youtube['api_key']
  config.log_level = :debug
end
