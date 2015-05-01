#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class PendingInvitesController < ApplicationController
      before_action :authenticate_user

      # GET /groups/pending_invites
      def index
        @pending_invites = current_user.pending_memberships_invites
      end
    end
  end
end
