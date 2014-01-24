module Socializer
  module ApplicationHelper
    def signin_path(provider)
      "/auth/#{provider.to_s}"
    end

    def current_user?(user)
      user == current_user
    end

    def separator
      content_tag(:span, :class => 'separator') do
        '&#8211;'.html_safe
      end
    end
  end
end
