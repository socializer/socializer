#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators that can be shared with the other decorators by inheriting from ApplicationDecorator
  class ApplicationDecorator < Draper::Decorator
    # Returns an HTML time tag
    #
    # @param options [Hash]
    #
    # @return [String] An HTML time tag
    def created_at_time_ago(options = {})
      time_ago(options: options)
    end

    private

    # Builds an HTML time tag
    #
    # @param options [Hash]
    #
    # @return [String] An HTML time tag
    def time_ago(options: {})
      created_at = model.created_at.utc

      options.reverse_merge! title: created_updated_tooltip_text

      options[:data] ||= {}
      options[:data][:time_ago] = "moment.js"

      helpers.time_tag(created_at, created_at.strftime("%B %e, %Y %l:%M%P"), options)
    end

    # TODO: make sure that note, comment, etc is touched when the ActivityObject is edited
    #
    # Creates the title/tooltip. If the model has been updated, it returns a multiline string.
    # If not, it returns the created_at value
    #
    # @param format [Symbol]
    #
    # @return [String]
    def created_updated_tooltip_text(format: :short)
      created_at = l(model.created_at.utc, format: format)
      updated_at = l(model.updated_at.utc, format: format)

      if created_at == updated_at
        created_at
      else
        # add `white-space: pre-wrap;` to .qtip-content
        "#{created_at} (edited #{updated_at})".html_safe
      end
    end
  end
end
