module Socializer
  class GroupsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group, only: [:edit, :update, :destroy]

    def index
    end

    def public
      @groups = Socializer::Group.public
    end

    def restricted
      @groups = Socializer::Group.restricted
    end

    def joinable
      @groups = Socializer::Group.joinable
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

      if @group.save
        redirect_to @group
      else
        render :new
      end
    end

    def edit
    end

    def update
      @group.update!(params[:group])
      redirect_to @group
    end

    def destroy
      @group.destroy
      redirect_to groups_path
    end

    private

    def set_group
      @group = current_user.groups.find(params[:id])
    end
  end
end
