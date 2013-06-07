require 'enumerize'

module Socializer
  class Engine < Rails::Engine
    isolate_namespace Socializer

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: true,
        controller_specs: true,
        request_specs: false
      g.integration_tool    false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  end
end
