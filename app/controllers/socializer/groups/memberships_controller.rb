#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    #
    # Memberships controller
    #
    class MembershipsController < ApplicationController
      before_action :authenticate_user

      # GET /groups/memberships
      def index
        @memberships = current_user.memberships
      end
    end
  end
end
