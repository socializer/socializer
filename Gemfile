source "http://rubygems.org"

gemspec

group :development do
  gem "coffeelint", "~> 1.14.0"
end

group :test do
  gem "cucumber-rails", "~> 1.4.4", require: false
  gem "database_cleaner", "~> 1.5.3"
  gem "simplecov", "~> 0.12.0", require: false
  gem "coveralls", "~> 0.8.15", require: false
end

group :development, :test do
  gem "byebug", "~> 9.0.5"
  gem "rspec-rails", "~> 3.5.1"
  gem "capybara", "~> 2.8.0"
  gem "rails-dummy", "~> 0.0.4"
  gem "pry", "~> 0.10.4"
end

# add these gems to help with the transition to Rails 4:
gem "protected_attributes", "~> 1.1.3"
