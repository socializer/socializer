# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for decorators related to the Person model
  class Person
    # Decorators for {Socializer::Person::Address}
    class AddressDecorator < Draper::Decorator
      delegate_all

      # Define presentation-specific methods here. Helpers are accessed through
      # `helpers` (aka `h`). You can override attributes, for example:
      #
      #   def created_at
      #     helpers.tag.span(class: 'time') do
      #       object.created_at.strftime("%a %m/%d/%y")
      #     end
      #   end

      # Returns the formatted address
      #
      # @example
      #   282 Kevin Brook
      #   Imogeneborough, California 58517
      #   US
      #
      # @return [String]
      def formatted_address
        address = [address_street]
        address << address_other
        address << address_city_state_postal
        address << model.country

        helpers.safe_join(address)
      end

      # Returns the city, stat/province and postal code on one line
      #
      # @example
      #   Imogeneborough, California 58517
      #
      # @return [String]
      def city_province_or_state_postal_code
        "#{model.city}, #{model.province_or_state} #{model.postal_code_or_zip}"
      end

      private

      def address_street
        content_and_br(content: model.line1)
      end

      def address_other
        content_and_br(content: model.line2) if model.line2?
      end

      def address_city_state_postal
        content_and_br(content: city_province_or_state_postal_code)
      end

      def content_and_br(content:)
        [content, helpers.tag.br]
      end
    end
  end
end
