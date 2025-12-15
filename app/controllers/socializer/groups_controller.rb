# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Groups controller
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
          render :show, locals: { group:, membership: }
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

    # Finds and memoizes the Group belonging to the `current_user` matching `params[:id]`.
    #
    # Uses memoization to avoid multiple DB queries during the same request.
    #
    # @return [Group, nil] the found Group or `nil` if none is found or the user has no access.
    #
    # @example
    #   # in a controller action:
    #   group = find_group
    #   if group
    #     render :show, locals: { group: group }
    #   else
    #     redirect_to groups_path, alert: 'Group not found'
    #   end
    def find_group
      return @find_group if defined?(@find_group)

      @find_group = current_user&.groups&.find_by(id: params[:id])
    end

    # Returns permitted parameters for Group operations.
    # Uses `params.expect` to require and permit attributes for creating/updating a Group.
    #
    # @return [ActionController::Parameters] filtered params containing permitted keys
    #
    # @example
    #   # in controller:
    #   #   group = current_user.groups.build(group_params)
    #   # permitted keys: :display_name, :privacy, :tagline, :about
    def group_params
      params.expect(group: %i[display_name privacy tagline about])
    end
  end
end
