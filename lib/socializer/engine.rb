# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Wraps Socializer"s functionality so that it can be shares with other
  # applications or within a larger packaged application.
  class Engine < Rails::Engine
    isolate_namespace Socializer

    config.generators do |generator|
      generator.test_framework :rspec,
                               fixtures: true,
                               view_specs: false,
                               helper_specs: false,
                               routing_specs: true,
                               controller_specs: true,
                               request_specs: true
      generator.helper false
      generator.integration_tool :rspec
      generator.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
