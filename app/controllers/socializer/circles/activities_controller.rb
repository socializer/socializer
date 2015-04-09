#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      # GET /circles/1/activities
      def index
        id          = params.fetch(:circle_id) { nil }
        @circle     = Circle.find_by(id: id).decorate
        @title      = @circle.display_name
        @current_id = @circle.guid
        # TODO: makes sense to have stream or activities as an instance method so we can do @circle.activities(viewer_id: current_user.id)
        @activities = Activity.circle_stream(actor_uid: id, viewer_id: current_user.id).decorate
      end
    end
  end
end
