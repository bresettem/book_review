source 'https://rubygems.org'
# Use for performance management system
gem 'newrelic_rpm', '4.2.0.334'
# Use for storing environment variables
gem 'figaro', '1.1.1'
# Use for storing images on production
gem 'aws-sdk', '2.10.17'
# Use to dump seeds
gem 'seed_dump', '3.2.4'
# Use for generating fake data for books, reviews, and users
gem 'faker', '1.8.4'
# Use for pagination
gem 'will_paginate', '3.1.6'
# Use for Bootstrap pagination
gem 'bootstrap-will_paginate', '1.0.0'
# Use to connect to Google Books API
gem 'googlebooks', '0.0.9'
# Use for adding read more
#gem 'readmorejs-rails', '0.0.12' # Does not support railties 5.0 which does not support Rails > 5.0
# Use for user profiles
gem 'devise', '4.3.0'
# Use for adding book covers
gem 'paperclip', '5.1.0'
# Install bootstrap 
gem 'bootstrap-sass', '3.3.7'
# Use for icons
gem 'font-awesome-rails', '4.7.0.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.3'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.2.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.2.2'
# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.1'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.7.0'
# Use pg as the database
gem 'pg'
# Use Redis adapter to run Action Cable in production
#gem 'redis', '3.3.3'
#Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Used for activemodel
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '2.14.4'
  # WebDriver is a tool for writing automated tests of websites. It aims to mimic the behaviour of a real user, and as such interacts with the HTML of the application.
  gem 'selenium-webdriver', '3.4.4'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '3.5.1'
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '2.0.1'
  # Use for generating favicons
  gem 'rails_real_favicon', '0.0.7'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-secrets-yml', '1.0.0'
  # Remove the following if your app does not use Rails
  gem 'capistrano-rails'

  # Remove the following if your server does not use RBENV
  gem 'capistrano-rbenv'
end

# Use postgresql as the database for production
group :production do
  # Use for rails logging
  gem 'rails_12factor'
  # Use for heroku server
  gem 'puma', '3.9.1'
  # Use for declaring the Ruby version for Heroku
  ruby '2.4.1'
end