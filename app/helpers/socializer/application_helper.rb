# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Methods added to this helper will be available to all templates in the
  # application.
  #
  module ApplicationHelper
    include ::Webpacker::Helper

    # Returns the current Webpacker instance.
    # Could be overridden to use multiple Webpacker
    # configurations within the same app (e.g. with engines).
    def current_webpacker_instance
      Socializer.webpacker
    end

    # Build the sign path for the given provider
    #
    # @param provider [String/Symbol]
    #
    # @return [String]
    def signin_path(provider)
      "/auth/#{provider}"
    end

    # Check if the current_user and the user are the same
    #
    # @param user [Socializer::Person]
    #
    # @return [TrueClass/FalseClass]
    def current_user?(user)
      user == current_user
    end
  end
end
