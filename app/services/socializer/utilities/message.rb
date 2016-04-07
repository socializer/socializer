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

      # Returns a localized error for an invalid record
      #
      # @return [String]
      #
      def record_invalid_message
        I18n.t("activerecord.errors.messages.record_invalid",
               errors: errors.full_messages.to_sentence)
      end

      # Creates an error message if the argument(s) passed to the
      # initializer are the wrong type
      #
      # @param [Class] instance: the instance you will be acting on
      # @param [Type] valid_class: the instance type that should be passed in
      #
      # @return [String]
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
