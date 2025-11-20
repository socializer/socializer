# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # ApplicationController is the base controller class for the application.
  # It inherits from ActionController::Base and includes common functionality
  # for all controllers.
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    # skip_before_action :verify_authenticity_token

    # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
    allow_browser versions: :modern
    # rate_limit to: 100, within: 1.minute, only: :create

    # Changes to the importmap will invalidate the etag for HTML responses
    # stale_when_importmap_changes

    helper_method :current_user
    helper_method :signed_in?

    before_action :set_locale

    protected

    # Ensures that a user is authenticated before allowing access.
    # Redirects to `root_path` when no signed-in user exists.
    #
    # @return [void]
    #
    # @example
    #   # when not signed in
    #   authenticate_user
    #   # => redirects to root_path
    def authenticate_user
      redirect_to root_path unless signed_in?
    end

    private

    # Returns the memoized current user for the request.
    # Memoizes the result in `@current_user` to avoid repeated lookups.
    # Delegates to `person` which reads the signed cookie and decorates the record.
    #
    # @return [Person, nil] the decorated Person instance or `nil` when not signed in
    #
    # @example
    #   # when cookies.signed[:user_id] == 42 and a Person with id 42 exists
    #   current_user # => #<PersonDecorator ...>
    def current_user
      return @current_user if defined?(@current_user)

      @current_user = person
    end

    # Returns whether a user is currently signed in.
    #
    # Uses the memoized `current_user` helper to determine presence.
    #
    # @return [Boolean] true when a signed-in user exists, otherwise false
    #
    # @example
    #   # when current_user is a Person instance
    #   signed_in? # => true
    #
    #   # when no current_user
    #   signed_in? # => false
    def signed_in?
      current_user.present?
    end

    # Determines whether the signed-in person's preferred language should be used
    # to set I18n.locale for the current request.
    #
    # Returns true when a user is signed in, the user's `language` attribute is
    # present and no explicit `params[:locale]` was provided.
    #
    # @return [Boolean] whether the person's language may be used for locale
    #
    # @example
    #   # when signed_in? == true, current_user.language == 'es' and params[:locale].blank?
    #   can_set_locale_from_person_language? # => true
    def can_set_locale_from_person_language?
      signed_in? && current_user.language.present? && params[:locale].blank?
    end

    # Determines the locale to use when the signed-in person's language should not be used.
    # Chooses the first available value from:
    #  - `params[:locale]`
    #  - the HTTP `Accept-Language` header via `extract_locale_from_accept_language_header`
    #  - `I18n.default_locale`
    #
    # @return [String, ActionController::Parameters] the chosen locale (two-letter code or the default locale)
    # @example
    #   # when params[:locale] == 'fr'
    #   can_not_set_locale_from_person_language # => 'fr'
    #
    #   # when params[:locale] is blank and Accept-Language == "en-US,en;q=0.9"
    #   can_not_set_locale_from_person_language # => 'en'
    #
    #   # when neither params nor header are present
    #   can_not_set_locale_from_person_language # => I18n.default_locale
    # @api private
    def can_not_set_locale_from_person_language
      params[:locale] || extract_locale_from_accept_language_header ||
        I18n.default_locale
    end

    # Sets the I18n.locale for the current request.
    # Prefers the signed-in person's language when available and `params[:locale]` is not provided.
    # Otherwise delegates to `can_not_set_locale_from_person_language` which checks:
    #   - `params[:locale]`
    #   - the HTTP `Accept-Language` header
    #   - `I18n.default_locale`
    #
    # @return [void]
    #
    # @example
    #   # when current_user.language == 'es' and params[:locale].blank?
    #   set_locale
    #   I18n.locale # => 'es'
    #
    #   # when params[:locale] == 'fr'
    #   set_locale
    #   I18n.locale # => 'fr'
    # @api private
    def set_locale
      I18n.locale = if can_set_locale_from_person_language?
                      current_user.language
                    else
                      can_not_set_locale_from_person_language
                    end
    end

    # Extracts the preferred locale from the raw HTTP `Accept-Language` header.
    # Returns the first two-letter language code found at the start of the header
    # (for example, `en` from `en-US,en;q=0.9`). Returns `nil` when no request or
    # header is present.
    #
    # @return [String, nil] two-letter locale code or `nil` if not available
    #
    # @example
    #   # when request.env["HTTP_ACCEPT_LANGUAGE"] == "en-US,en;q=0.9"
    #   extract_locale_from_accept_language_header # => "en"
    def extract_locale_from_accept_language_header
      return if request.blank? || http_accept_language.blank?

      request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
    end

    # Returns the raw HTTP Accept-Language header from the request environment.
    # Memoizes the value in `@http_accept_language` so subsequent calls avoid
    # repeated env lookups.
    #
    # @return [String, nil] the raw `HTTP_ACCEPT_LANGUAGE` header value or `nil` when absent
    #
    # @example
    #   # when request.env["HTTP_ACCEPT_LANGUAGE"] == "en-US,en;q=0.9"
    #   http_accept_language # => "en-US,en;q=0.9"
    # @api private
    def http_accept_language
      return @http_accept_language if defined?(@http_accept_language)

      @http_accept_language = request.env["HTTP_ACCEPT_LANGUAGE"]
    end

    # Returns the current signed-in Person based on the signed cookie.
    #
    # Memoizes the lookup in `@person`. Reads the signed `:user_id` cookie,
    # finds the corresponding Person record, and decorates it before returning.
    #
    # @return [Person, nil] the decorated Person instance or `nil` if not available
    #
    # @example
    #   # when cookies.signed[:user_id] == 42 and a Person with id 42 exists
    #   person # => #<PersonDecorator ...>
    def person
      return @person if defined?(@person)

      cookie_user_id = cookies.signed[:user_id]

      return if cookie_user_id.blank?

      @person = Person.find_by(id: cookie_user_id).decorate
    end
  end
end
