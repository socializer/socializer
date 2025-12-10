# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators that can be shared with the other decorators by inheriting
  # from ApplicationDecorator
  class ApplicationDecorator < Draper::Decorator
    # @param options [Hash] Options forwarded to the internal `time_ago` helper.
    # @option options [String] :class CSS classes added to the generated time tag.
    # @option options [String] :title Tooltip/title text for the time tag (defaults to created/updated tooltip).
    # @option options [Hash] :data HTML data attributes (defaults are merged for JS behavior).
    #
    # @return [String] HTML-safe time tag with tooltip and data attributes.
    #
    # @example
    #   # => adds default tooltip and data attributes for moment.js
    #   decorator.created_at_time_ago(class: 'timestamp small')
    # @api private
    def created_at_time_ago(options = {})
      time_ago(options:)
    end

    private

    # Internal helper that builds a time tag for the model's `created_at` timestamp,
    # merging default tooltip/title and JavaScript data attributes.
    #
    # @param options [Hash] Options forwarded to the internal `time_tag` helper.
    #
    # @option options [String] :class CSS classes added to the generated time tag.
    # @option options [String] :title Tooltip/title text for the time tag (defaults to created/updated tooltip).
    # @option options [Hash] :data HTML data attributes (defaults are merged for JS behavior).
    #
    # @return [String] HTML-safe time tag with tooltip and data attributes.
    #
    # @example
    #   # => adds default tooltip and data attributes for moment.js
    #   decorator.time_ago(class: 'timestamp small')
    def time_ago(options: {})
      data = { behavior: "tooltip-on-hover", time_ago: "moment.js" }

      options.reverse_merge!(title: created_updated_tooltip_text, data:)

      time_tag(options:)
    end

    # Builds an HTML time tag for the model's `created_at` timestamp.
    #
    # @param options [Hash] Options forwarded to `helpers.time_tag`.
    #
    # @option options [String] :class CSS classes added to the generated time tag.
    # @option options [String] :title Tooltip/title text for the time tag (defaults to created/updated tooltip).
    # @option options [Hash] :data HTML data attributes (defaults are merged by the caller).
    #
    # @return [String] HTML-safe time tag representing the model's creation time.
    #
    # @example
    #   # Adds default tooltip and data attributes for moment.js
    #   time_tag(options: { class: 'timestamp small' })
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
