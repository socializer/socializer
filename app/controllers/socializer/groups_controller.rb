#
# Namespace for the Socializer engine
#
module Socializer
  class GroupsController < ApplicationController
    before_action :authenticate_user
    before_action :set_group, only: [:edit, :update, :destroy]

    # GET /groups
    def index
    end

    # GET /groups/1
    def show
      @group = Group.find_by(id: params[:id])
      @membership = Membership.find_by(group_id: @group.id)
    end

    # GET /groups/new
    def new
      @group = Group.new
    end

    # GET /groups/1/edit
    def edit
    end

    # POST /groups
    def create
      @group = current_user.groups.build(params[:group])

      if @group.save
        flash[:notice] = t('socializer.model.create', model: 'Group')
        redirect_to @group
      else
        render :new
      end
    end

    # PATCH/PUT /groups/1
    def update
      @group.update!(params[:group])

      flash[:notice] = t('socializer.model.update', model: 'Group')
      redirect_to @group
    end

    # DELETE /groups/1
    def destroy
      @group.destroy
      redirect_to groups_path
    end

    # GET /groups/:id/invite/:user_id
    def invite
      invited_user = Person.find_by(id: params[:user_id])
      group = Group.find_by(id: params[:id])
      group.invite(invited_user)

      redirect_to group
    end

    # GET /groups/public
    def public
      @groups = Group.public
    end

    # GET /groups/restricted
    def restricted
      @groups = Group.restricted
    end

    # GET /groups/ownerships
    def ownerships
      @ownerships = current_user.groups
    end

    # GET /groups/pending_invites
    def pending_invites
      @pending_invites = current_user.pending_memberships_invites
    end

    private

    def set_group
      @group = current_user.groups.find_by(id: params[:id])
    end
  end
end
