# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Base error class
  #
  class Error < StandardError
  end

  #
  # Module Errors provides engine specific errors
  #
  module Errors
    # Raised when the record is invalid.
    class RecordInvalid < Socializer::Error
    end

    #
    # Raised when someone tries to join a private goup instead of being invited.
    #
    class PrivateGroupCannotSelfJoin < Socializer::Error
      #
      # Override Exception#message
      #
      # @return [String] Returns the error's message
      def message
        I18n.t("socializer.errors.messages.group.private.cannot_self_join")
      end
    end
  end
end
