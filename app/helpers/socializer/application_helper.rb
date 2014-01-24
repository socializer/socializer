module Socializer
  module ApplicationHelper
    def signin_path(provider)
      "/auth/#{provider.to_s}"
    end

    def current_user?(user)
      user == current_user
    end

    # TODO: separator - This should be removed and a separator CSS class should be created/update
    #                   to use the :before pseudo selector with it's content set to &ndash;
    def separator
      content_tag(:span, class: 'separator') do
        '&#8211;'.html_safe
      end
    end
  end
end
