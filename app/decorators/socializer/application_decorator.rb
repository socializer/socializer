module Socializer
  class ApplicationDecorator < Draper::Decorator
    def created_at_time_ago(options = {})
      time_ago(model.created_at, options)
    end

    private

    def time_ago(time, options = {})
      time = time.to_time.utc

      options.reverse_merge! title: l(time, format: :short)

      options[:data] ||= {}
      options[:data].merge! time_ago: 'moment.js'

      h.time_tag time, time.strftime('%B %e, %Y %l:%M%P'), options
    end
  end
end
