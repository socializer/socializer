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

      # Returns an HTML-safe fragment combining the address components:
      # first line (line1), optional second line (line2), city/province/state/postal,
      # and country. Each component is followed by an HTML line break and the parts
      # are joined via `helpers.safe_join`.
      #
      # @return [ActiveSupport::SafeBuffer] an HTML-safe string containing the formatted address
      #
      # @example
      #   formatted_address
      #   # => "282 Kevin Brook<br>Suite 100<br>Imogeneborough, California 58517<br>United States"
      def formatted_address
        address = [address_street]
        address << address_other
        address << address_city_state_postal
        address << model.country

        helpers.safe_join(address)
      end

      # Returns a formatted string combining city, province/state and postal code.
      #
      # @return [String] e.g. "Imogeneborough, California 58517"
      #
      # @example
      #   city_province_or_state_postal_code #=> "Imogeneborough, California 58517"
      def city_province_or_state_postal_code
        "#{model.city}, #{model.province_or_state} #{model.postal_code_or_zip}"
      end

      private

      # Returns the first address line (line1) followed by an HTML line break,
      # suitable for joining via `helpers.safe_join`.
      #
      # @return [Array] an array containing the street content and a `br` tag
      #
      # @example
      #   # => ["282 Kevin Brook", #<ActiveSupport::SafeBuffer ...>]
      def address_street
        content_and_br(content: model.line1)
      end

      # Returns the second address line (line2) followed by an HTML line break when present.
      #
      # @return [Array, nil] an array suitable for `helpers.safe_join` (content string and `br` tag), or `nil` when `line2` is blank
      #
      # @example
      #   # => ["Suite 100", #<ActiveSupport::SafeBuffer ...>]
      def address_other
        content_and_br(content: model.line2) if model.line2?
      end

      # Returns the city/province/state and postal code followed by an HTML line break,
      # suitable for joining via `helpers.safe_join`.
      #
      # @return [Array] an array containing the formatted location string and a `br` tag
      #
      # @example
      #   # => ["Imogeneborough, California 58517", #<ActiveSupport::SafeBuffer ...>]
      #   address_city_state_postal
      def address_city_state_postal
        content_and_br(content: city_province_or_state_postal_code)
      end

      # Returns an array of the given content followed by an HTML line break node.
      #
      # @param content [String] the content to display before the line break
      #
      # @return [Array] an array suitable for `helpers.safe_join`, containing the content and a `br` tag
      #
      # @example
      #   # => ["282 Kevin Brook", #<ActiveSupport::SafeBuffer ...>]
      #   content_and_br(content: "282 Kevin Brook")
      def content_and_br(content:)
        [content, helpers.tag.br]
      end
    end
  end
end
