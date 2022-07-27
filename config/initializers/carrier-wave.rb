# frozen_string_literal: true

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'minioadmin',
    aws_secret_access_key: 'minioadmin',
    region: 'us-east-1',
    host: 'localhost',
    endpoint: 'http://localhost:9000',
    path_style: true
  }
  config.fog_directory  = 'avatar'
  config.fog_public     = true
end
