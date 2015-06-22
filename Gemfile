source 'http://rubygems.org'

gemspec

group :test do
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'database_cleaner', '~> 1.4.1'
  gem 'simplecov', '~> 0.10.0', require: false
  gem 'coveralls', '~> 0.8.1', require: false
end

group :development, :test do
  gem 'byebug', '~> 5.0.0'
  gem 'rspec-rails', '~> 3.3.1'
  gem 'capybara', '~> 2.4.4'
  gem 'rails-dummy', '~> 0.0.4'
  gem 'pry', '~> 0.10.1'
end

# add these gems to help with the transition to Rails 4:
gem 'protected_attributes', '~> 1.1.0'
