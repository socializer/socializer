# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    #
    # Activities controller
    #
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      # GET /circles/1/activities
      def index
        circle_id = params.fetch(:circle_id, nil)
        circle    = Circle.find_by(id: circle_id).decorate
        # @current_id = @circle.guid
        # TODO: makes sense to have stream or activities as an instance
        #       method so we can do
        #       circle.activities(viewer_id: current_user.id)

        activities = stream(circle:)

        render :index, locals: { activities:,
                                 circle:,
                                 title: circle.display_name }
      end

      private

      def stream(circle:)
        return @stream if defined?(@stream)

        @stream = Activity.circle_stream(actor_uid: circle.id,
                                         viewer_id: current_user.id).decorate
      end
    end
  end
end
