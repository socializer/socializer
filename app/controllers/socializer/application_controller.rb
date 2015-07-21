#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Application controller
  #
  class ApplicationController < ActionController::Base
    helper_method :current_user
    helper_method :signed_in?

    before_action :set_locale

    protected

    def authenticate_user
      redirect_to root_path unless signed_in?
    end

    private

    def current_user
      @current_user ||= person
    end

    # Check if a user is signed in
    #
    # @return [TrueClass/FalseClass]
    def signed_in?
      current_user.present?
    end

    def set_locale
      if signed_in? && current_user.language.present? && params[:locale].blank?
        I18n.locale =  current_user.language
      else
        I18n.locale =  params[:locale] ||
          extract_locale_from_accept_language_header ||
          I18n.default_locale
      end
    end

    def extract_locale_from_accept_language_header
      return unless request.present? && http_accept_language.present?
      request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
    end

    private

    def http_accept_language
      @http_accept_language ||= request.env["HTTP_ACCEPT_LANGUAGE"]
    end

    def person
      @person ||= if cookies[:user_id].present?
                    Person.find_by(id: cookies.signed[:user_id]).decorate
                  end
    end
  end
end
