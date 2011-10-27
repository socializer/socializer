module Socializer
  class GroupsController < ApplicationController
    
    def index
      @groups = current_user.groups
      @memberships = current_user.memberships
    end
  
    def show
      @group = Group.find(params[:id])
      @membership = Membership.find_by_group_id(@group.id)
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
      @group.update_attributes!(params[:group])
      redirect_to @group
    end
    
    def destroy
      @group = current_user.groups.find(params[:id])
      @group.destroy
      redirect_to groups_path
    end
  
  end
end
