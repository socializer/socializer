#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Memberships controller
  #
  class MembershipsController < ApplicationController
    before_action :authenticate_user

    # POST /memberships
    def create
      @group = Group.find_by(id: params[:membership][:group_id])
      @group.join(person: current_user)
      redirect_to @group
    end

    # DELETE /memberships/1
    def destroy
      @membership = current_user.memberships.find_by(id: params[:id])
      @group = @membership.group
      @group.leave(person: current_user)
      redirect_to @group
    end
  end
end
