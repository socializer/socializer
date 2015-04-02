#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class MembershipsController < ApplicationController
      def index
        @memberships = current_user.memberships
      end
    end
  end
end
