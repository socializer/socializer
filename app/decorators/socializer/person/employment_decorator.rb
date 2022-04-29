# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for decorators related to the Person model
  class Person
    # Decorators for {Socializer::Person::Employment}
    class EmploymentDecorator < Draper::Decorator
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

      # Returns the formatted employment
      #
      # @example
      #   Employer Name
      #   My Title
      #   Job description
      #   February 20th, 2015 - February 28th, 2015
      #
      # @return [String]
      def formatted_employment
        employment = [content_and_br(content: model.employer_name)]
        employment << job_title_with_br_or_empty
        employment << job_description_with_br_or_empty
        employment << started_on_to_ended_on

        helpers.safe_join(employment)
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

      def job_title_with_br_or_empty
        content_and_br(content: model.job_title) if model.job_title?
      end

      def job_description_with_br_or_empty
        return unless model.job_description?

        content_and_br(content: model.job_description)
        # if model.job_description?
        #   return content_and_br(content: model.job_description)
        # end
      end
    end
  end
end
