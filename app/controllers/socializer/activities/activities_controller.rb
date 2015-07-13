#
# Namespace for the Socializer engine
#
module Socializer
  module Activities
    #
    # Activities controller
    #
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      # GET activities/1/activities
      def index
        id          = params.fetch(:activity_id) { nil }
        @activity   = Activity.find_by(id: id).decorate
        @title      = "Activity stream"
        @current_id = nil
        @note       = Note.new
        # TODO: makes sense to have stream or activities as an instance
        #       method so we can do
        #       @activity.activities(viewer_id: current_user.id)
        @activities = stream
      end

      private

      def stream
        @stream ||= Activity.activity_stream(actor_uid: @activity.id,
                                             viewer_id: current_user.id)
                            .decorate
      end
    end
  end
end
