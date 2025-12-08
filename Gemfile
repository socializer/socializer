# frozen_string_literal: true

# source "https://rubygems.org"
source "https://gem.coop"

# Specify your gem's dependencies in socializer.gemspec.
gemspec

gem "sprockets-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  # gem "rubocop-rails-omakase", require: false

  gem "rspec-rails", "~> 8.0"

  gem "rubocop", "~> 1.7", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-performance", "~> 1.21", require: false
  gem "rubocop-rails", "~> 2.25", require: false
  gem "rubocop-rake", "~> 0.6", require: false
  gem "rubocop-rspec", "~> 3.0", require: false
  gem "rubocop-rspec_rails", require: false
  gem "rubocop-thread_safety", require: false
  # gem "solargraph", "~> 0.50.0"
  # gem "solargraph-rails"
  # gem "solargraph-rails", "~> 1.0.0.pre.1"

  gem "byebug"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rails-dummy", "= 0.1.1"
  gem "sqlite3"
  gem "typeprof"
  gem "yard-lint"
end

group :development do
  gem "brakeman", "~> 7.0"
  gem "bundler", ">= 1.15.0", "< 3.0"
  gem "coffeelint", "~> 1.16.1"
  gem "i18n-tasks", "~> 1.1.0"
  gem "inch", "~> 0.8.0"
  gem "listen"
  gem "rails_best_practices", "~> 1.23.0"
  gem "rake", "~> 13.0"
  # gem "ruby-lsp"
  # gem "ruby-lsp-rspec", require: false
  gem "scss_lint", "~> 0.60.0"
  gem "shoulda-matchers", "~> 7.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15", "< 4.0"
  gem "coveralls_reborn", "~> 0.29.0", require: false
  # gem "cucumber-rails", "~> 1.5.0", require: false
  gem "database_cleaner-active_record", "~> 2.0"
  gem "selenium-webdriver", "~> 4.39"
  gem "simplecov", "~> 0.22.0", require: false
  gem "simplecov-lcov", require: false

  # TODO: Update test so rails-controller-testing can be removed
  gem "rails-controller-testing"
  # net-smtp should be removable when a new version of the mikel/mail
  # gem is released
  gem "net-smtp", require: false
end

# gem "draper", github: "drapergem/draper"

gem "bundler-integrity", "~> 1.0"

# TODO: Move back to the gemspec once the gem is released
# gem "jquery-ui-rails", github: "jquery-ui-rails/jquery-ui-rails"
# gem "jquery-ui-rails", github: "jquery-ui-rails/jquery-ui-rails",
#                        tag: "v7.0.0"
