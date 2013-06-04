module Socializer
  class ApplicationController < ActionController::Base

    helper_method :current_user
    helper_method :signed_in?

    private

    def current_user
      @current_user ||= Person.find(cookies[:user_id]) if cookies[:user_id].present?
    end

    def signed_in?
      current_user.present?
    end
  end
end
