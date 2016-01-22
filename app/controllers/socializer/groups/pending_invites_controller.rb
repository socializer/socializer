#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    #
    # Pending Invites controller
    #
    class PendingInvitesController < ApplicationController
      before_action :authenticate_user

      # GET /groups/pending_invites
      def index
        @pending_invites = current_user.pending_membership_invites
      end
    end
  end
end
