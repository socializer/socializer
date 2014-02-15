module Socializer
  class SessionsController < ApplicationController
    def create
      auth = request.env['omniauth.auth']
      user_auth = Authentication.where(provider: auth.provider, uid: auth.uid).first

      if user_auth.nil?
        if signed_in?
          current_user.authentications.create!(provider: auth.provider, uid: auth.uid)
          redirect_to authentications_path
        else
          user = Person.create_with_omniauth(auth)
          user.add_default_circle
        end
      else
        user = user_auth.person if user_auth.present?
      end

      if user
        cookies[:user_id] = { domain: :all, value: "#{user.id}" }
        redirect_to root_url
      end
    end

    def destroy
      cookies.delete :user_id, domain: :all
      redirect_to root_url
    end

    def failure
      redirect_to root_url
    end
  end
end
