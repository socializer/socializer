#
# Namespace for the Socializer engine
#
module Socializer
  class SessionsController < ApplicationController
    def create
      auth      = request.env['omniauth.auth']
      user_auth = Authentication.find_by(provider: auth.provider, uid: auth.uid)

      if user_auth.nil?
        add_authentication(auth) if signed_in?
        create_authentication(auth) unless signed_in?
      else
        login(user_auth.person)
      end
    end

    def destroy
      cookies.delete :user_id, domain: :all
      redirect_to root_url
    end

    def failure
      redirect_to root_url
    end

    private

    def add_authentication(auth)
      current_user.authentications.create!(provider: auth.provider, uid: auth.uid)
      redirect_to authentications_path
    end

    def create_authentication(auth)
      user = Person.create_with_omniauth(auth)
      user.add_default_circles
      login(user)
    end

    def login(user)
      cookies[:user_id] = { domain: :all, value: "#{user.id}" }
      redirect_to root_url
    end
  end
end
