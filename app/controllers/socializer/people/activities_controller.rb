#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      def index
        id          = params.fetch(:person_id) { nil }
        @person     = Person.find_by(id: id).decorate
        @title      = @person.display_name
        @current_id = @person.guid
        # TODO: makes sense to have stream or activities as an instance method so we can do @person.activities(viewer_id: current_user.id)
        @activities = Activity.person_stream(actor_uid: id, viewer_id: current_user.id).decorate
      end
    end
  end
end
