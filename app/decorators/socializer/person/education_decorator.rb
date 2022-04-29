# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for decorators related to the Person model
  class Person
    # Decorators for {Socializer::Person::Education}
    class EducationDecorator < Draper::Decorator
      delegate_all

      # Define presentation-specific methods here. Helpers are accessed through
      # `helpers` (aka `h`). You can override attributes, for example:
      #
      #   def created_at
      #     helpers.tag.span(class: 'time') do
      #       object.created_at.strftime("%a %m/%d/%y")
      #     end
      #   end

      #  Attributes

      # Returns the ended_on date using the long_ordinal format
      #
      # @example
      #   February 28th, 2015
      #
      # @return [String]
      def ended_on
        model.ended_on.to_date.to_fs(:long_ordinal) if model.ended_on?
      end

      # Returns the started_on date using the long_ordinal format
      #
      # @example
      #   February 20th, 2015
      #
      # @return [String]
      def started_on
        model.started_on.to_date.to_fs(:long_ordinal) if model.started_on?
      end

      # Returns the formatted education
      #
      # @example
      #   Harvard
      #   Economics
      #   February 20th, 2015 - February 28th, 2015
      #
      # @return [String]
      def formatted_education
        education = []
        education << content_and_br(content: model.school_name)

        if model.major_or_field_of_study?
          education << content_and_br(content: model.major_or_field_of_study)
        end

        education << started_on_to_ended_on

        helpers.safe_join(education)
      end

      # Returns the started_on and ended_on dates using the long_ordinal format
      #
      # @example
      #   February 20th, 2015 - February 28th, 2015
      #
      # @return [String]
      def started_on_to_ended_on
        ended = current? ? "present" : ended_on
        "#{started_on} - #{ended}"
      end

      private

      def content_and_br(content:)
        [content, helpers.tag.br]
      end
    end
  end
end
