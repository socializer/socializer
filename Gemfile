source "http://rubygems.org"

gemspec

gem 'sass-rails',   '~> 4.0.0.rc2'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'

gem 'omniauth-identity'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-openid'

# TODO: Remove when final version ships for Rails 4
gem "squeel", github: 'ernie/squeel'

group :development, :test do
  gem 'debugger'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'cucumber-rails', :require => false, github: 'cucumber/cucumber-rails', :branch => 'master_rails4_test'
  gem 'database_cleaner'
end

# add these gems to help with the transition to Rails 4:
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
