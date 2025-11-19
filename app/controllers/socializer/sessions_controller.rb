# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Sessions controller
  #
  class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create

    # GET|POST /auth/facebook/callback
    def create
      user_auth = Authentication.find_by(provider: auth_hash.provider,
                                         uid: auth_hash.uid)

      return login(user_auth.person) if user_auth.present?

      add_authentication(auth_hash) if signed_in?
      create_authentication(auth_hash) unless signed_in?
    end

    # GET|DELETE /signout
    def destroy
      cookies.delete :user_id, domain: :all
      redirect_to root_url
    end

    # GET|POST /auth/failure
    def failure
      redirect_to root_url
    end

    private

    # Adds an authentication record to the currently signed-in user and redirects to the authentications list.
    #
    # @param auth [OmniAuth::AuthHash, Hash] OmniAuth authentication hash (expected to respond to `provider` and `uid`).
    #
    # @return [void]
    #
    # @example
    #   # Called from an omniauth callback when a signed-in user links a new provider:
    #   add_authentication(auth_hash)
    def add_authentication(auth)
      current_user.authentications.create!(provider: auth.provider,
                                           uid: auth.uid)

      redirect_to authentications_path
    end

    # Creates a new Person record from the supplied OmniAuth hash, adds default circles for the new person,
    # and logs the person in by delegating to `login`.
    #
    # @param auth [OmniAuth::AuthHash, Hash] Authentication data provided by OmniAuth (expected to respond to `provider` and `uid`).
    #
    # @return [void]
    #
    # @example
    #   # Called from an omniauth callback when a new user signs up:
    #   create_authentication(auth_hash)
    def create_authentication(auth)
      user = Person.create_with_omniauth(auth)
      AddDefaultCircles.call(person: user)
      login(user)
    end

    # Logs in the given user by setting a signed, domain-wide cookie and redirecting to root.
    #
    # @param user [Person] The user to log in; expected to respond to `id`.
    #
    # @return [void]
    #
    # @example
    #   # After creating or finding a user in an omniauth callback:
    #   login(user)
    def login(user)
      cookies.signed[:user_id] = { domain: :all, value: user.id.to_s }
      redirect_to root_url
    end

    protected

    # Retrieves the OmniAuth authentication hash from the Rack request environment.
    #
    # @return [Hash, OmniAuth::AuthHash, nil] Authentication data provided by the OmniAuth strategy, or nil if not available.
    #
    # @example
    #   # In an omniauth callback action:
    #   auth = auth_hash
    #   provider = auth[:provider] # or auth.provider
    #   uid = auth[:uid]
    def auth_hash
      request.env["omniauth.auth"]
    end
  end
end
