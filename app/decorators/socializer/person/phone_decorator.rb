# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for decorators related to the Person model
  class Person
    # Decorators for {Socializer::Person::Phone}
    class PhoneDecorator < Draper::Decorator
      delegate_all

      # Define presentation-specific methods here. Helpers are accessed through
      # `helpers` (aka `h`). You can override attributes, for example:
      #
      #   def created_at
      #     helpers.tag.span(class: 'time') do
      #       object.created_at.strftime("%a %m/%d/%y")
      #     end
      #   end

      # Returns a safe HTML fragment combining the phone label and number.
      # The label is titleized, and a separator is inserted between label and number.
      #
      # @return [ActiveSupport::SafeBuffer] HTML-safe string produced by `helpers.safe_join`
      #
      # @example
      #   # => "Home : 555-1234"
      #   decorator.label_and_number
      def label_and_number
        content = []
        content << model.label.titleize
        content << " : "
        content << model.number

        helpers.safe_join(content)
      end
    end
  end
end
