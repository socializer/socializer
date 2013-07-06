module Socializer
  class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

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
