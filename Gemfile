# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.6'

gem 'config', '~> 4.0'

gem 'bootsnap', require: false
gem 'carrierwave'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'fog-aws'
gem 'importmap-rails'
gem 'jbuilder'
gem 'kaminari', '~> 1.2', '>= 1.2.2'
gem 'mini_magick', '~> 4.11'
gem 'pg', '~> 1.1'
gem 'pg_search', '~> 2.3', '>= 2.3.6'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'
gem 'redis', '~> 4.0'
gem 'sidekiq'
gem 'sidekiq-cron', '~> 0.4.2'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'
  gem 'rspec-rails', '~> 5.1', '>= 5.1.2'
end

group :development do
  gem 'tailwindcss-rails', '~> 2.0', '>= 2.0.10'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner-active_record', '~> 2.0', '>= 2.0.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'pry-byebug', '~> 3.9'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webdrivers'
end

gem 'jquery-rails', '~> 4.4'
