#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class MembershipsController < ApplicationController
      before_action :authenticate_user

      # GET /groups/memberships
      def index
        @memberships = current_user.memberships
      end
    end
  end
end
