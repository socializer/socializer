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

      # Returns the ended_on date using the `:long_ordinal` format.
      #
      # @return [String, nil] formatted date string when present, otherwise `nil`
      #
      # @example
      #   decorator.ended_on # => "February 28th, 2015"
      def ended_on
        model.ended_on.to_date.to_fs(:long_ordinal) if model.ended_on?
      end

      # Returns the started_on date using the `:long_ordinal` format.
      #
      # @return [String, nil] formatted date string when present, otherwise `nil`
      #
      # @example
      #   # => "February 20th, 2015"
      def started_on
        model.started_on.to_date.to_fs(:long_ordinal) if model.started_on?
      end

      # Returns the formatted education details as safe HTML. Combines the school
      # name, optional major/field of study, and the start/end dates separated by
      # `<br>` tags. Intended for display in views.
      #
      # @return [ActiveSupport::SafeBuffer] HTML-safe string with components joined
      #   by line breaks.
      #
      # @example
      #   # => "University of Example<br>Computer Science<br>February 20th, 2015 - February 28th, 2015"
      def formatted_education
        education = []
        education << content_and_br(content: model.school_name)

        education << content_and_br(content: model.major_or_field_of_study) if model.major_or_field_of_study?

        education << started_on_to_ended_on

        helpers.safe_join(education)
      end

      # Returns the started_on and ended_on dates using the long_ordinal format
      #
      # @return [String]
      #
      # @example
      #   February 20th, 2015 - February 28th, 2015
      def started_on_to_ended_on
        ended = current? ? "present" : ended_on
        "#{started_on} - #{ended}"
      end

      private

      # Build a two-element array containing the provided content and an HTML line
      # break tag. Intended for use with `helpers.safe_join` to produce a
      # HTML-safe joined output.
      #
      # @param content [String] the text or HTML-safe content to render before the break
      #
      # @return [Array<Object>] an array where the second element is `helpers.tag.br`
      #
      # @example
      #   content_and_br(content: "University of Example") # => ["University of Example", helpers.tag.br]
      def content_and_br(content:)
        [content, helpers.tag.br]
      end
    end
  end
end
