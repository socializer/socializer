# frozen_string_literal: true

OmniAuth.config.allowed_request_methods = [:post]
# OmniAuth.config.before_request_phase = TokenVerifier.new

require "omniauth"
require "omniauth-identity"
require "omniauth-facebook"
require "omniauth-twitter"
require "omniauth-linkedin"
require "omniauth-openid"

require "openid/store/filesystem"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :open_id, store: OpenID::Store::Filesystem.new("/tmp"),
                     name: "yahoo",
                     identifier: "yahoo.com"

  provider :open_id, store: OpenID::Store::Filesystem.new("/tmp"),
                     name: "google",
                     identifier: "https://www.google.com/accounts/o8/id"

  provider :twitter,  ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"]
  provider :facebook, ENV["FACEBOOK_KEY"], ENV["FACEBOOK_SECRET"]
  provider :linkedin, ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECRET"]

  provider :identity, model: Socializer::Identity
end
