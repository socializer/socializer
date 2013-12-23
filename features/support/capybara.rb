Bundler.require :default, :test

require 'socializer'

require 'capybara'
require 'capybara/rails'
# require 'capybara/cucumber'

World(Capybara::RSpecMatchers)
World(Capybara::DSL)

Capybara.save_and_open_page_path = 'tmp/capybara'

combustion_rack_builder = eval 'Rack::Builder.new {( ' + File.read(File.dirname(__FILE__) + '/../../config.ru') + "\n )}"
Capybara.app = combustion_rack_builder.to_app
World { Capybara.app.routes.url_helpers }
