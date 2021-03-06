CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => 'S3_KEY',
    :aws_secret_access_key => 'S3_SECRET'
  }

  config.fog_directory = 'Marko'
  config.fog_public = true
  config.fog_attributes = { 'Cache-Control' => 'max-age=60000' }
end


