# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for activity-related controllers
  #
  module Activities
    #
    # Activities controller
    #
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      # GET activities/1/activities
      def index
        activity_id = params.fetch(:activity_id, nil)

        # TODO: makes sense to have stream or activities as an instance
        #       method so we can do
        #       @activity.activities(viewer_id: current_user.id)
        activities = stream(activity_id:)

        render :index, locals: { activities:, title: "Activity stream" }
      end

      private

      def stream(activity_id:)
        return @stream if defined?(@stream)

        activity = Activity.find_by(id: activity_id).decorate

        @stream = Activity.activity_stream(actor_uid: activity.id,
                                           viewer_id: current_user.id)
                          .decorate
      end
    end
  end
end
