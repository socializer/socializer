module Socializer
  module ApplicationHelper
    def signin_path(provider)
      "/auth/#{provider.to_s}"
    end

    def current_user?(user)
      user == current_user
    end

    def time_ago(time, options = {})
      time = time.to_time.utc

      options.reverse_merge! title: l(time, format: :short)

      options[:data] ||= {}
      options[:data].merge! time_ago: 'moment.js'

      time_tag time, time.strftime('%B %e, %Y %l:%M%P'), options
    end
  end
end
