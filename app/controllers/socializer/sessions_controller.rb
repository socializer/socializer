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

    def add_authentication(auth)
      current_user.authentications.create!(provider: auth.provider,
                                           uid: auth.uid)

      redirect_to authentications_path
    end

    def create_authentication(auth)
      user = Person.create_with_omniauth(auth)
      AddDefaultCircles.call(person: user)
      login(user)
    end

    def login(user)
      cookies.signed[:user_id] = { domain: :all, value: user.id.to_s }
      redirect_to root_url
    end

    protected

    # Retrieves the authentication hash from the OmniAuth request environment.
    #
    # @example
    #   auth_hash = auth_hash()
    #   puts auth_hash['provider'] # => 'facebook'
    #
    # @return [Hash] the authentication hash containing provider and uid information
    def auth_hash
      request.env["omniauth.auth"]
    end
  end
end
