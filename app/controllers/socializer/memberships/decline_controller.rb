#
# Namespace for the Socializer engine
#
module Socializer
  module Memberships
    #
    # Decline controller
    #
    class DeclineController < ApplicationController
      before_action :authenticate_user

      # DELETE /memberships/1/decline
      def destroy
        @membership = Membership.find_by(id: params[:id])
        @membership.destroy

        redirect_to groups_pending_invites_path
      end
    end
  end
end
