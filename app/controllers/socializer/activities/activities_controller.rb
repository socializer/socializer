# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Module for activity-related controllers
  module Activities
    # Activities controller
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

      # Retrieves the activity stream for the given activity id and memoizes the result.
      #
      # @param activity_id [Integer, nil] ID of the activity whose actor stream should be loaded.
      #   When nil, the behavior depends on downstream callers (may return a global stream).
      #
      # @return [Object] Decorated stream (an ActiveRecord relation or collection decorated via Draper).
      #
      # @example
      #   # fetch and render the activity stream for activity with id 15
      #   stream(activity_id: 15)
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
