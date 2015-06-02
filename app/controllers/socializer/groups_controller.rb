#
# Namespace for the Socializer engine
#
module Socializer
  class GroupsController < ApplicationController
    before_action :authenticate_user

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
      @group = find_group
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
      @group = find_group
      @group.update!(params[:group])

      flash[:notice] = t('socializer.model.update', model: 'Group')
      redirect_to @group
    end

    # DELETE /groups/1
    def destroy
      @group = find_group
      @group.destroy
      redirect_to groups_path
    end

    # POST /groups/:id/invite/:person_id
    def invite
      invited_user = Person.find_by(id: params[:person_id])
      group = Group.find_by(id: params[:id])
      group.invite(invited_user)

      redirect_to group
    end

    private

    def find_group
      current_user.groups.find_by(id: params[:id])
    end
  end
end
