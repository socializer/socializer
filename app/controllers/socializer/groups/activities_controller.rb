# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Module for grouping related controllers
  module Groups
    # Activities controller
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      # GET /groups/1/activities
      def index
        group_id = params.fetch(:group_id, nil)
        group    = Group.find_by(id: group_id).decorate
        # @current_id = @group.guid
        # TODO: makes sense to have stream or activities as an instance
        #       method so we can do
        #       @group.activities(viewer_id: current_user.id)

        activities = stream(group:)

        render :index, locals: { activities:,
                                 group:,
                                 title: group.display_name }
      end

      private

      # Returns the activity stream for the provided group, memoized in `@stream`.
      #
      # @param group [Group] the group whose activity stream will be retrieved
      #
      # @return [Object] a decorated collection representing the group's activities
      #
      # @example
      #   # Fetch and memoize activities for a group
      #   activities = stream(group: @group)
      def stream(group:)
        return @stream if defined?(@stream)

        @stream = Activity.group_stream(actor_uid: group.id,
                                        viewer_id: current_user.id).decorate
      end
    end
  end
end
