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

    initializer "webpacker.proxy" do |app|
      insert_middleware = begin
                            MyEngine.webpacker.config.dev_server.present?
                          rescue
                            nil
                        end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy,
        ssl_verify_none: true,
        webpacker: MyEngine.webpacker
      )

      config.app_middleware.use(
        Rack::Static,
        urls: ["/socializer-packs"], root: "socializer/public"
      )
    end
  end
end
