# frozen_string_literal: true

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV.fetch('aws_access_key_id', nil),
    aws_secret_access_key: ENV.fetch('aws_secret_access_key', nil),
    region: ENV.fetch('region', nil),
    host: 'localhost',
    endpoint: 'http://localhost:9000',
    path_style: true
  }
  config.fog_directory  = ENV.fetch('bucket', nil)
  config.fog_public     = true
end
