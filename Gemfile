source 'http://rubygems.org'

gemspec

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'      # For RailsPanel
end

group :test do
  gem 'cucumber-rails', '~> 1.4.0', require: false
  gem 'database_cleaner'
  gem 'simplecov', '~> 0.8.2', require: false
  gem 'coveralls', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'rails-dummy'
end

# add these gems to help with the transition to Rails 4:
gem 'protected_attributes'
# gem 'rails-observers'
# gem 'actionpack-page_caching'
# gem 'actionpack-action_caching'
