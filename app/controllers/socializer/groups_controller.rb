# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Groups controller
  #
  class GroupsController < ApplicationController
    before_action :authenticate_user

    # GET /groups
    def index
      render :index
    end

    # GET /groups/1
    def show
      group = Group.find_by(id: params[:id])
      membership = Membership.find_by(group_id: group.id)

      respond_to do |format|
        format.html do
          render :show, locals: { group: group, membership: membership }
        end
      end
    end

    # GET /groups/new
    def new
      respond_to do |format|
        format.html { render :new, locals: { group: Group.new } }
      end
    end

    # GET /groups/1/edit
    def edit
      respond_to do |format|
        format.html { render :edit, locals: { group: find_group } }
      end
    end

    # POST /groups
    def create
      group = current_user.groups.build(group_params)

      if group.save
        flash[:notice] = t("socializer.model.create", model: "Group")
        redirect_to group_path(group)
      else
        render :new
      end
    end

    # PATCH/PUT /groups/1
    def update
      group = find_group
      group.update!(group_params)

      flash[:notice] = t("socializer.model.update", model: "Group")
      redirect_to group_path(group)
    end

    # DELETE /groups/1
    def destroy
      group = find_group
      group.destroy
      redirect_to groups_path
    end

    private

    def find_group
      @find_group ||= current_user.groups.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:display_name, :privacy, :tagline, :about)
    end
  end
end
