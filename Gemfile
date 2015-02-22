source 'http://rubygems.org'

gemspec

group :test do
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'database_cleaner'
  gem 'simplecov', '~> 0.9.2', require: false
  gem 'coveralls', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'rails-dummy'
  gem 'pry', '~> 0.10.1'
end

# add these gems to help with the transition to Rails 4:
gem 'protected_attributes'
