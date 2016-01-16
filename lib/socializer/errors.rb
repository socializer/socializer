#
# Namespace for the Socializer engine
#
module Socializer
  # Base error class
  class Error < StandardError
  end

  module Errors
    # Raised when the record is invalid.
    class RecordInvalid < Socializer::Error
    end

    # Raised when someone tries to join a private goup instead of being invited.
    class PrivateGroupCannotSelfJoin < Socializer::Error
      def message
        I18n.t("socializer.errors.messages.group.private.cannot_self_join")
      end
    end
  end
end
