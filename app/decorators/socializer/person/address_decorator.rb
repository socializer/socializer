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
      #     helpers.content_tag :span, class: 'time' do
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
        address = "#{model.line1} <br>"
        address << "#{model.line2} <br>" if model.line2?
        address << "#{city_province_or_state_postal_code} <br>"
        address << model.country

        address.html_safe
      end

      # Returns the city, stat/province and postal code on one line
      #
      # @example
      #   Imogeneborough, California 58517
      #
      # @return [String]
      def city_province_or_state_postal_code
        "#{model.city}, #{model.province_or_state} #{model.postal_code_or_zip}"
          .html_safe
      end
    end
  end
end
