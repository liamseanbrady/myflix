source 'https://rubygems.org'
ruby '2.1.6'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt-ruby', '~> 3.1.0'
gem 'sidekiq'
gem 'carrierwave'
gem 'mini_magick'
gem 'stripe'
gem 'figaro'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'capybara-email'
  gem 'webmock'
  gem 'vcr'
  gem 'selenium-webdriver'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'sentry-raven'
  gem 'unicorn'
  gem 'carrierwave-aws'
end

