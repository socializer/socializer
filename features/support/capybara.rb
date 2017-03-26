# frozen_string_literal: true

Bundler.require :default, :test

require "socializer"

require "capybara"
require "capybara/rails"
# require "capybara/cucumber"

World(Capybara::RSpecMatchers)
World(Capybara::DSL)

Capybara.save_and_open_page_path = "tmp/capybara"

World { Capybara.app.routes.url_helpers }
