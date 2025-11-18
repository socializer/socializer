# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module Utilities provides utility functions
  #
  module Utilities
    #
    # Module Message provides message related functions
    #
    module Message
      module_function

      # Generates an error message for an instance of the wrong type.
      #
      # @param instance [Object] the instance that has the wrong type
      # @param valid_class [Class] the class that the instance should be
      #
      # @return [String] the error message
      #
      # @example
      #   wrong_type_message(instance: "string", valid_class: Integer)
      #   # => "Expected argument to be of type Integer, but got String"
      def wrong_type_message(instance:, valid_class:)
        valid_class_name = valid_class.name

        I18n.t("socializer.errors.messages.wrong_instance_type",
               argument: valid_class_name.demodulize.downcase,
               valid_class: valid_class_name,
               invalid_class: instance.class.name)
      end
    end
  end
end
