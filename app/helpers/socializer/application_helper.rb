#
# Namespace for the Socializer engine
#
module Socializer
  module ApplicationHelper
    def signin_path(provider)
      "/auth/#{provider}"
    end

    def current_user?(user)
      user == current_user
    end
  end
end
