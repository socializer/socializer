#
# Namespace for the Socializer engine
#
module Socializer
  class MembershipsController < ApplicationController
    before_action :authenticate_user
    before_action :set_membership, only: [:approve, :confirm, :decline]

    # POST /memberships
    def create
      @group = Group.find_by(id: params[:membership][:group_id])
      @group.join(current_user)
      redirect_to @group
    end

    # DELETE /memberships/1
    def destroy
      @membership = current_user.memberships.find_by(id: params[:id])
      @group = @membership.group
      @group.leave(current_user)
      redirect_to @group
    end

    # POST /memberships/1/approve
    def approve
      @membership.approve
      redirect_to @membership.group
    end

    alias_method :confirm, :approve

    # # POST /memberships/1/confirm
    # def confirm
    #   @membership.confirm
    #   redirect_to @membership.group
    # end

    # POST /memberships/1/decline
    def decline
      @membership.decline
      redirect_to groups_pending_invites_path
    end

    private

    def set_membership
      @membership = Membership.find_by(id: params[:id])
    end
  end
end
