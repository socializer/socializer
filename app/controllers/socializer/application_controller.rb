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

    def can_set_locale_from_person_language?
      signed_in? && current_user.language.present? && params[:locale].blank?
    end

    def can_not_set_locale_from_person_language
      params[:locale] || extract_locale_from_accept_language_header ||
        I18n.default_locale
    end

    def set_locale
      I18n.locale = if can_set_locale_from_person_language?
                      current_user.language
                    else
                      can_not_set_locale_from_person_language
                    end
    end

    def extract_locale_from_accept_language_header
      return unless request.present? && http_accept_language.present?
      request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
    end

    def http_accept_language
      @http_accept_language ||= request.env["HTTP_ACCEPT_LANGUAGE"]
    end

    def person
      cookie_user_id = cookies.signed[:user_id]

      @person ||= if cookie_user_id.present?
                    Person.find_by(id: cookie_user_id).decorate
                  end
    end
  end
end
