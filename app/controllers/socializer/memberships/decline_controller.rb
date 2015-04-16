#
# Namespace for the Socializer engine
#
module Socializer
  module Memberships
    class DeclineController <ApplicationController
      # DELETE /memberships/1/decline
      def destroy
        @membership = Membership.find_by(id: params[:id])
        @membership.destroy

        redirect_to groups_pending_invites_path
      end
    end
  end
end
