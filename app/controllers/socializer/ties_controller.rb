# frozen_string_literal: true

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
      circle = Circle.find_by(id: tie_params[:circle_id])
      tie = circle.add_contact(tie_params[:contact_id])

      flash_message(action: :create, tie:, circle:)
      respond_to do |format|
        # format.html { redirect_to circle }
        format.js
      end
    end

    # DELETE /ties/1
    def destroy
      tie = Tie.find_by(id: params[:id])
      circle = tie.circle

      tie.destroy

      flash_message(action: :destroy, tie:, circle:)

      redirect_to circle
    end

    private

    def flash_message(action:, tie:, circle:)
      flash.now.notice = t("socializer.model.tie.#{action.to_s.downcase}",
                           person_name: tie.contact.display_name,
                           circle_name: circle.display_name)
    end

    # Only allow a list of trusted parameters through.
    def tie_params
      params.expect(tie: %i[contact_id circle_id])
    end
  end
end
