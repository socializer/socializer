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

      flash[:notice] = flash_message(action: :create,
                                     person_name: display_name(tie: tie))
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

      flash[:notice] = flash_message(action: :destroy,
                                     person_name: display_name(tie: @tie))

      redirect_to @circle
    end

    private

    def display_name(tie:)
      tie.contact.display_name
    end

    def flash_message(action:, person_name:)
      flash[:notice] = t("socializer.model.tie.#{action.to_s.downcase}",
                         person_name: person_name,
                         circle_name: @circle.display_name)
    end
  end
end
