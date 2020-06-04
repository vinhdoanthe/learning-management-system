Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Settings.youtube['client_id'], Settings.youtube['client_secret'] 
end
