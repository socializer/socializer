# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Activities controller
  class ActivitiesController < ApplicationController
    before_action :authenticate_user

    # GET /activities
    def index
      activities = Activity.stream(viewer_id: current_user.id).decorate

      render :index, locals: { activities:,
                               current_id: nil,
                               title: "Activity stream",
                               note: Note.new }
    end

    # DELETE /activities/1
    def destroy
      activity = find_activity
      activity.destroy

      respond_to do |format|
        format.js do
          render :destroy, locals: { activity_guid: activity.guid }
        end
      end
    end

    private

    # Finds the Activity corresponding to `params[:id]`.
    # This private helper returns the activity record or `nil` when not found.
    #
    # @return [Activity, nil]
    #
    # @example
    #   activity = find_activity
    #   if activity
    #     activity.destroy
    #   end
    def find_activity
      Activity.find_by(id: params[:id])
    end
  end
end
