# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators that can be shared with the other decorators by inheriting
  # from ApplicationDecorator
  class ApplicationDecorator < Draper::Decorator
    # Returns an HTML time tag
    #
    # @param options [Hash]
    #
    # @return [String] An HTML time tag
    def created_at_time_ago(options = {})
      time_ago(options:)
    end

    private

    # Builds an HTML time tag
    #
    # @param options [Hash]
    #
    # @return [String] An HTML time tag
    def time_ago(options: {})
      data = { behavior: "tooltip-on-hover", time_ago: "moment.js" }

      options.reverse_merge!(title: created_updated_tooltip_text, data:)

      time_tag(options:)
    end

    def time_tag(options:)
      created_at = model.created_at.utc

      helpers.time_tag(created_at,
                       created_at.strftime("%B %e, %Y %l:%M%P"),
                       options)
    end

    # TODO: make sure that note, comment, etc is touched when the
    #       ActivityObject is edited
    #
    # Creates the title/tooltip. If the model has been updated, it returns
    # a multiline string.
    # If not, it returns the created_at value
    #
    # @param format [Symbol]
    #
    # @return [String]
    def created_updated_tooltip_text(format: :short)
      created_at = l(model.created_at.utc, format:)
      updated_at = l(model.updated_at.utc, format:)

      return created_at if created_at == updated_at

      # add `white-space: pre-wrap;` to .qtip-content
      "#{created_at} (edited #{updated_at})"
    end
  end
end
