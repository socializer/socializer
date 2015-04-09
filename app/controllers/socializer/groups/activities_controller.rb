#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      # GET /groups/1/activities
      def index
        id          = params.fetch(:group_id) { nil }
        @group      = Group.find_by(id: id).decorate
        @title      = @group.display_name
        @current_id = @group.guid
        # TODO: makes sense to have stream or activities as an instance method so we can do @group.activities(viewer_id: current_user.id)
        @activities = Activity.group_stream(actor_uid: id, viewer_id: current_user.id).decorate
      end
    end
  end
end
