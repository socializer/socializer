#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Activities controller
  #
  class ActivitiesController < ApplicationController
    before_action :authenticate_user

    # GET /activities
    def index
      @activities = Activity.stream(viewer_id: current_user.id).decorate
      @current_id = nil
      @title      = 'Activity stream'
      @note       = Note.new
    end

    # DELETE /activities/1
    def destroy
      @activity = find_activity
      @activity_guid = @activity.guid
      @activity.destroy

      respond_to do |format|
        format.js
      end
    end

    private

    def find_activity
      Activity.find_by(id: params[:id])
    end
  end
end
