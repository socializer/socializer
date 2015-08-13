#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators for {Socializer::PersonEducation}
  class PersonEducationDecorator < Draper::Decorator
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: 'time' do
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
      model.ended_on.to_date.to_s(:long_ordinal) if model.ended_on?
    end

    # Returns the started_on date using the long_ordinal format
    #
    # @example
    #   February 20th, 2015
    #
    # @return [String]
    def started_on
      model.started_on.to_date.to_s(:long_ordinal) if model.started_on?
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
      education = "#{model.school_name} <br>"
      education << "#{model.major_or_field_of_study} <br>" if model.major_or_field_of_study?
      education << "#{started_on_to_ended_on}"

      education.html_safe
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
  end
end
