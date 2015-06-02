#
# Namespace for the Socializer engine
#
module Socializer
  class ActivitiesController < ApplicationController
    before_action :authenticate_user
    before_action :set_activity, only: [:destroy]

    # GET /activities
    def index
      @activities = Activity.stream(viewer_id: current_user.id).decorate
      @current_id = nil
      @title      = 'Activity stream'
      @note       = Note.new
    end

    # DELETE /activities/1
    def destroy
      @activity_guid = @activity.guid
      @activity.destroy

      respond_to do |format|
        format.js
      end
    end

    private

    def set_activity
      @activity = Activity.find_by(id: params[:id])
    end
  end
end
