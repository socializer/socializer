# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in socializer.gemspec.
gemspec

gem "sprockets-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
  gem "byebug"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "rails-dummy", "= 0.1.0"
  gem "rspec-rails", "~> 5.1.0"
  gem "sqlite3"
  gem "typeprof"
end

group :development do
  gem "coffeelint", "~> 1.16.1"
  gem "listen"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15", "< 4.0"
  gem "coveralls_reborn", "~> 0.25.0", require: false
  # gem "cucumber-rails", "~> 1.5.0", require: false
  gem "database_cleaner-active_record", "~> 2.0"
  gem "simplecov", "~> 0.21.2", require: false
  gem "simplecov-lcov", require: false
  gem "webdrivers", "~> 5.0"

  # TODO: Update test so rails-controller-testing can be removed
  gem "rails-controller-testing"
  # net-smtp should be removable when a new version of the mikel/mail
  # gem is released
  gem "net-smtp", require: false
end

# gem "draper", github: "drapergem/draper"

gem "bundler-integrity", "~> 1.0"
