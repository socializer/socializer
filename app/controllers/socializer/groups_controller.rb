module Socializer
  class GroupsController < ApplicationController

    def index
    end

    def memberships
        @memberships = current_user.memberships
    end

    def ownerships
        @ownerships = current_user.groups
    end

    def pending_invites
        @pending_invites = current_user.pending_memberships_invites
    end

    def show
      @group = Group.find(params[:id])
      @membership = Membership.find_by(group_id: @group.id)
    end

    def new
      @group = Group.new
    end

    def create
      @group = current_user.groups.build(params[:group])
      @group.save!
      redirect_to @group
    end

    def edit
      @group = current_user.groups.find(params[:id])
    end

    def update
      @group = current_user.groups.find(params[:id])
      @group.update!(params[:group])
      redirect_to @group
    end

    def destroy
      @group = current_user.groups.find(params[:id])
      @group.destroy
      redirect_to groups_path
    end

  end
end
