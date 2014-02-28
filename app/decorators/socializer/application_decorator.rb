module Socializer
  class ApplicationDecorator < Draper::Decorator
    # Returns an HTML time tag
    #
    # @param options [Hash]
    #
    # @return [String]
    def created_at_time_ago(options = {})
      time_ago(created_at: model.created_at, updated_at: model.updated_at, options: options)
    end

    private

    # Builds an HTML time tag
    #
    # @param created_at [DateTime]
    # @param updated_at [DateTime]
    # @param options [Hash]
    #
    # @return [String] An HTML time tag
    def time_ago(created_at:, updated_at:, options: {})
      created_at = created_at.to_time.utc
      updated_at = updated_at.to_time.utc

      options.reverse_merge! title: created_updated_tooltip(created_at: created_at, updated_at: updated_at)

      options[:data] ||= {}
      options[:data].merge! time_ago: 'moment.js'

      h.time_tag created_at, created_at.strftime('%B %e, %Y %l:%M%P'), options
    end

    # TODO: make sure that note, comment, etc is edited the ActivityObject is touched as well
    # Creates the title/tooltip. If the model has been updated, it returns a multiline string.
    # If not, it returns the created_at value
    #
    # @param created_at [DateTime]
    # @param updated_at [DateTime]
    # @param format [Symbol]
    #
    # @return [String]
    def created_updated_tooltip(created_at: time, updated_at:, format: :short)
      created_at = l(created_at, format: format)
      updated_at = l(updated_at, format: format)

      if created_at == updated_at
        created_at
      else
        # add `white-space: pre-wrap;` to .qtip-content
        "#{created_at}&#10;(edited #{updated_at})".html_safe
      end
    end
  end
end
