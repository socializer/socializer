# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Application controller
  #
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    # skip_before_action :verify_authenticity_token

    allow_browser versions: :modern
    # rate_limit to: 100, within: 1.minute, only: :create

    helper_method :current_user
    helper_method :signed_in?

    before_action :set_locale

    protected

    # Redirect to the root path if the vistor is not signed in
    def authenticate_user
      redirect_to root_path unless signed_in?
    end

    private

    def current_user
      return @current_user if defined?(@current_user)

      @current_user = person
    end

    # Check if a user is signed in
    #
    # @return [Boolean]
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
      return if request.blank? || http_accept_language.blank?

      request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
    end

    def http_accept_language
      return @http_accept_language if defined?(@http_accept_language)

      @http_accept_language = request.env["HTTP_ACCEPT_LANGUAGE"]
    end

    def person
      return @person if defined?(@person)

      cookie_user_id = cookies.signed[:user_id]

      return if cookie_user_id.blank?

      @person = Person.find_by(id: cookie_user_id).decorate
    end
  end
end
