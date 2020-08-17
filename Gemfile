source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

ruby '2.6.5'

## Manual added gems
# For Translation
gem 'i18n'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use for store enums
  gem 'enumerize'
# User for administration
gem 'rails_admin', '~> 2.0'
gem 'cancancan'
gem 'cancancan-mongoid'

gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'composite_primary_keys', '~> 12.0'
gem 'tinymce-rails'
gem 'discard', '~> 1.2'
gem 'paper_trail'

# Notification
gem 'activity_notification'

# Pagination
gem 'bootstrap-sass'
# Chart for Reporting

# Image processing
gem "aws-sdk-s3", require: false

gem 'image_processing'
gem "lazyload-rails"
gem 'yt', '~> 0.32.0'
gem 'mini_magick'
gem 'image_optim'
gem 'image_optim_pack'
# gem 'image_optim_rails'
gem 'sendgrid-ruby'
# For import/export
gem 'caxlsx_rails'

# For cronjob/delay job
gem 'whenever', require: false

# jQuery
gem 'jquery-rails'
# Used for storing secret variables
gem 'config'
# Used to call to oDoo
gem 'xmlrpc'

# Cookie
gem 'activerecord-session_store'

# Deployment gems
gem 'capistrano', '~> 3.11'
gem 'capistrano-rails', '~> 1.4'
gem 'capistrano-passenger', '~> 0.2.0'
gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'

## End manual added gems

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use MongoDB for store key-value object
gem "mongoid", "~> 7.0.2"
gem 'rspec-rails'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Monitoring gems
gem 'newrelic_rpm'
gem 'appsignal'

gem 'sentry-raven'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'listen', '>= 3.0.5', '< 3.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry', '~> 0.12.2'
  gem 'pry-rails', '~> 0.3.9'
  gem 'pry-nav'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# group :assets do
#   gem 'coffee-rails', '~> 4.1.0'
# end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# gem "simple_calendar", "~> 2.0"
gem 'spreadsheet', '~> 1.2', '>= 1.2.6'
gem 'kaminari-mongoid'
gem 'kaminari'
gem 'remotipart', '~> 1.4'
