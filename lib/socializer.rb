# frozen_string_literal: true

require "socializer/engine"
require "socializer/errors"

# Added "jquery-ui-rails" for drag and drop
require "jquery/ui/rails"
require "coffee-rails"
require "sass/rails"
require "bootstrap-sass"
require "draper"
require "enumerize"
require "omniauth"
require "omniauth-identity"
require "omniauth-facebook"
require "omniauth-linkedin"
require "omniauth-openid"
require "omniauth-twitter"
require "simple_form"
require "country_select"
require "webpacker"

#
# Namespace for the Socializer engine
#
module Socializer
  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))

  class << self
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join("config/webpacker.yml")
      )
    end
  end
end
