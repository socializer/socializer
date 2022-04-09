# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    #
    # Activities controller
    #
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

      def stream(group:)
        @stream ||= Activity.group_stream(actor_uid: group.id,
                                          viewer_id: current_user.id).decorate
      end
    end
  end
end
