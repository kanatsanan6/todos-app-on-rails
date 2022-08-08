# frozen_string_literal: true

require 'sidekiq/middleware/i18n'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', nil) }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', nil) }
end

schedule_file = 'config/schedule.yml'
Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file)) if File.exist?(schedule_file) && Sidekiq.server?
