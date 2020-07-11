CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => 'amazon'
  }
  config.fog_directory = 'uploads-with-fog'
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end
