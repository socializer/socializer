# Added 'jquery-ui-rails' for drag and drop
require 'jquery/ui/rails'
require 'coffee-rails'
require 'sass/rails'
require 'bootstrap-sass'
require 'draper'
require 'enumerize'
require 'omniauth'
require 'omniauth-identity'
require 'omniauth-facebook'
require 'omniauth-linkedin'
require 'omniauth-openid'
require 'omniauth-twitter'
require 'simple_form'

#
# Namespace for the Socializer engine
#
module Socializer
  class Engine < Rails::Engine
    isolate_namespace Socializer

    config.generators do |generator|
      generator.test_framework :rspec,
                               fixtures: true,
                               view_specs: false,
                               helper_specs: false,
                               routing_specs: true,
                               controller_specs: true,
                               request_specs: false
      generator.integration_tool false
      generator.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
