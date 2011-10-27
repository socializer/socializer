module Socializer
  class MembershipsController < ApplicationController
    
    def create
      @group = Group.find(params[:membership][:group_id])
      @group.join(current_user)
      redirect_to @group
    end
    def destroy
      @membership = current_user.memberships.find(params[:id])
      @group = @membership.group
      @group.leave(current_user)
      redirect_to @group  
    end 
    
    def approve
      @membership = Membership.find(params[:id])
      @membership.approve!
      redirect_to @membership.group
    end
    
    def invite
      invited_user = Person.find(params[:user_id])
      group = Group.find(params[:group_id])
      group.invite(invited_user)
      redirect_to group
    end
    
    def confirm
      @membership = Membership.find(params[:id])
      @membership.confirm!
      redirect_to @membership.group
    end
    
  end
end
