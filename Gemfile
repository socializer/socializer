# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in socializer.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
  gem "byebug", "~> 11.1.1"
  gem "pry", "~> 0.12.2"
  gem "rails-dummy", "= 0.1.0"
  gem "rspec-rails", "~> 3.9.0"
end

group :development do
  gem "coffeelint", "~> 1.16.1"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15", "< 4.0"
  gem "coveralls_reborn", "~> 0.15.0", require: false
  # gem "cucumber-rails", "~> 1.5.0", require: false
  gem "database_cleaner-active_record", "~> 1.8"
  gem "simplecov", "~> 0.18.5", require: false
  gem "webdrivers", "~> 4.0"

  # TODO: Update test so rails-controller-testing can be removed
  gem "rails-controller-testing"
end
