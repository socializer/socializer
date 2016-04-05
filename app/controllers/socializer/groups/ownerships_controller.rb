#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    # TODO: This may belong under people
    #
    # Ownerships controller
    #
    class OwnershipsController < ApplicationController
      before_action :authenticate_user

      # GET /groups/ownerships
      def index
        @ownerships = current_user.groups
      end
    end
  end
end
