# frozen_string_literal: true

require "omniauth"
require "omniauth-identity"
require "omniauth-facebook"
require "omniauth-twitter"
require "omniauth-linkedin"
require "omniauth-openid"

require "openid/store/filesystem"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :open_id, store: OpenID::Store::Filesystem.new("/tmp"),
                     name: "yahoo",
                     identifier: "yahoo.com"

  provider :open_id, store: OpenID::Store::Filesystem.new("/tmp"),
                     name: "google",
                     identifier: "https://www.google.com/accounts/o8/id"

  provider :twitter,  ENV.fetch("TWITTER_KEY"), ENV.fetch("TWITTER_SECRET")
  provider :facebook, ENV.fetch("FACEBOOK_KEY"), ENV.fetch("FACEBOOK_SECRET")
  provider :linkedin, ENV.fetch("LINKEDIN_KEY"), ENV.fetch("LINKEDIN_SECRET")

  provider :identity, model: Socializer::Identity
end
