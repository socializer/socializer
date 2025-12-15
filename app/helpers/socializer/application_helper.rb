# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Methods added to this helper will be available to all templates in the
  # application.
  module ApplicationHelper
    # Build the sign path for the given provider
    #
    # @param provider [String, Symbol]
    #
    # @return [String]
    def signin_path(provider)
      "/auth/#{provider}"
    end

    # Check if the current_user and the user are the same
    #
    # @param user [Socializer::Person]
    #
    # @return [Boolean]
    def current_user?(user)
      user == current_user
    end
  end
end
