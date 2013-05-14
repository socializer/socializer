module Socializer
  module ApplicationHelper

    def signin_path(provider)
      "/auth/#{provider.to_s}"
    end

    def current_user?(user)
      user == current_user
    end

  end
end
