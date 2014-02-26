module Socializer
  class ApplicationDecorator < Draper::Decorator
    # @param [Hash] options
    #
    # @return [String] An HTML time tag
    def created_at_time_ago(options = {})
      time_ago(created_at: model.created_at, updated_at: model.updated_at, options: options)
    end

    private

    # @param [DateTime] created_at
    # @param [DateTime] updated_at
    # @param [Hash] options
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
    #
    # @param [DateTime] created_at
    # @param [DateTime] updated_at
    # @param [Object] format
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
