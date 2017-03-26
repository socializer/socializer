# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Sessions controller
  #
  class SessionsController < ApplicationController
    # GET|POST /auth/facebook/callback
    def create
      auth      = request.env["omniauth.auth"]
      user_auth = Authentication.find_by(provider: auth.provider,
                                         uid: auth.uid)

      return login(user_auth.person) if user_auth.present?

      add_authentication(auth) if signed_in?
      create_authentication(auth) unless signed_in?
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
  end
end
