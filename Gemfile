source "http://rubygems.org"

gemspec

group :development do
  gem "coffeelint", "~> 1.14.0"
end

group :test do
  gem "cucumber-rails", "~> 1.4.3", require: false
  gem "database_cleaner", "~> 1.5.1"
  gem "simplecov", "~> 0.11.1", require: false
  gem "coveralls", "~> 0.8.10", require: false
end

group :development, :test do
  gem "byebug", "~> 8.2.1"
  gem "rspec-rails", "~> 3.4.1"
  gem "capybara", "~> 2.6.2"
  gem "rails-dummy", "~> 0.0.4"
  gem "pry", "~> 0.10.3"
end

# add these gems to help with the transition to Rails 4:
gem "protected_attributes", "~> 1.1.3"
