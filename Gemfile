source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gemspec

group :development do
  gem "coffeelint", "~> 1.14.0"
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "coveralls", "~> 0.8.19", require: false
  gem "cucumber-rails", "~> 1.4.5", require: false
  gem "database_cleaner", "~> 1.5.3"
  gem "simplecov", "~> 0.12.0", require: false

  # TODO: Update test so rails-controller-testing can be removed
  gem "rails-controller-testing"
end

group :development, :test do
  gem "byebug", "~> 9.0.6"
  gem "capybara", "~> 2.11.0"
  gem "pry", "~> 0.10.4"
  gem "rails-dummy", "~> 0.0.4"
  gem "rspec-rails", "~> 3.5.2"
end

# TODO: Remove. add these gems to help with the transition to Rails 5:
gem "protected_attributes_continued"
