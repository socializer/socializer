#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Ties controller
  #
  class TiesController < ApplicationController
    before_action :authenticate_user

    # POST /ties
    def create
      tie_params = params[:tie]

      @circle = Circle.find_by(id: tie_params[:circle_id])
      tie = @circle.add_contact(tie_params[:contact_id])

      flash[:notice] = flash_message(action: :create, tie: tie)
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

      flash[:notice] = flash_message(action: :destroy, tie: @tie)

      redirect_to @circle
    end

    private

    def flash_message(action:, tie:)
      flash[:notice] = t("socializer.model.tie.#{action.to_s.downcase}",
                         person_name: tie.contact.display_name,
                         circle_name: @circle.display_name)
    end
  end
end
