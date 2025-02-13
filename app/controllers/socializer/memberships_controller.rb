# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Memberships controller
  #
  class MembershipsController < ApplicationController
    before_action :authenticate_user

    # POST /memberships
    def create
      group = Group.find_by(id: membership_params[:group_id])

      Group::Services::Join.new(group:, person: current_user).call

      redirect_to group
    end

    # DELETE /memberships/1
    def destroy
      membership = current_user.memberships.find_by(id: params[:id])
      group = membership.group

      Group::Services::Leave.new(group:, person: current_user).call

      redirect_to group
    end

    private

    # Only allow a list of trusted parameters through.
    def membership_params
      params.expect(membership: [:group_id])
    end
  end
end
