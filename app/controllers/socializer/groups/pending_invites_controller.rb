# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for grouping related controllers
  #
  module Groups
    # TODO: This may belong under people
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
