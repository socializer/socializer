module Socializer
  class MembershipsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_membership, only: [:approve, :confirm, :decline]

    def create
      @group = Group.find_by(id: params[:membership][:group_id])
      @group.join(current_user)
      redirect_to @group
    end

    def destroy
      @membership = current_user.memberships.find_by(id: params[:id])
      @group = @membership.group
      @group.leave(current_user)
      redirect_to @group
    end

    def approve
      @membership.approve!
      redirect_to @membership.group
    end

    def invite
      invited_user = Person.find_by(id: params[:user_id])
      group = Group.find_by(id: params[:group_id])
      group.invite(invited_user)
      redirect_to group
    end

    def confirm
      @membership.confirm!
      redirect_to @membership.group
    end

    def decline
      @membership.decline!
      redirect_to groups_pending_invites_path
    end

    private

    def set_membership
      @membership = Membership.find_by(id: params[:id])
    end
  end
end
