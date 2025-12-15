# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for grouping related controllers
  #
  module Groups
    # Invitations controller
    class InvitationsController < ApplicationController
      before_action :authenticate_user

      # POST /groups/:id/invite/:person_id
      def create
        invited_user = Person.find_by(id: params[:person_id])
        group = Group.find_by(id: params[:id])
        Group::Services::Invite.new(group:, person: invited_user).call

        redirect_to group
      end
    end
  end
end
