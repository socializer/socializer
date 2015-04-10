#
# Namespace for the Socializer engine
#
module Socializer
  class TiesController < ApplicationController
    before_action :authenticate_user

    # POST /ties
    def create
      @circle = Circle.find_by(id: params[:tie][:circle_id])
      tie = @circle.add_contact(params[:tie][:contact_id])

      flash[:notice] = t('socializer.model.tie.create', person_name: tie.contact.display_name, circle_name: @circle.display_name)

      respond_to do |format|
        # format.html { redirect_to @circle }
        format.js
      end
    end

    # DELETE /ties/1
    def destroy
      @tie = Tie.find_by(id: params[:id])
      @circle = @tie.circle
      @tie.destroy

      flash[:notice] = t('socializer.model.tie.destroy', person_name: @tie.contact.display_name, circle_name: @circle.display_name)
      redirect_to @circle
    end
  end
end
