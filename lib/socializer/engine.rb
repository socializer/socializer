# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Wraps Socializer"s functionality so that it can be shares with other
  # applications or within a larger packaged application.
  class Engine < ::Rails::Engine
    isolate_namespace Socializer

    initializer "socializer.set_factory_paths",
                after: "factory_bot.set_factory_paths" do
      if defined?(FactoryBot) && !Rails.env.production?
        definition_file_paths = File.join(Engine.root, "spec", "factories")
        FactoryBot.definition_file_paths.prepend(definition_file_paths)
      end
    end

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
