source 'http://rubygems.org'

ruby '2.1.0'

gemspec

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'jquery-rails'

gem 'omniauth-identity'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-openid'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'      # For RailsPanel
end

group :test do
  gem 'cucumber-rails', '~> 1.4.0', :require => false
  gem 'database_cleaner'
  gem 'simplecov', '~> 0.8.2', :require => false
end

group :development, :test do
  gem 'debugger'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'rails-dummy'
end

# add these gems to help with the transition to Rails 4:
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
