source "https://rubygems.org"

# Declare your gem's dependencies in socializer.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gemspec

group :development do
  gem "coffeelint", "~> 1.16.0"
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "coveralls", "~> 0.8.21", require: false
  # gem "cucumber-rails", "~> 1.4.5", require: false
  gem "database_cleaner", "~> 1.6.1"
  gem "simplecov", "~> 0.14.1", require: false

  # TODO: Update test so rails-controller-testing can be removed
  gem "rails-controller-testing"
end

group :development, :test do
  gem "byebug", "~> 9.0.6"
  gem "capybara", "~> 2.14.0"
  gem "pry", "~> 0.10.4"
  gem "rails-dummy", "~> 0.0.4"
  gem "rspec-rails", "~> 3.6.0"
end

# TODO: Remove. add these gems to help with the transition to Rails 5:
gem "protected_attributes_continued"
