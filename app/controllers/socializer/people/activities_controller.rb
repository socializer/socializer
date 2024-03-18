# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Activities controller
    #
    class ActivitiesController < ApplicationController
      before_action :authenticate_user

      # GET /people/1/activities
      def index
        person_id = params.fetch(:person_id, nil)
        person    = Person.find_by(id: person_id).decorate
        # @current_id = @person.guid
        # TODO: makes sense to have stream or activities as an instance
        #       method so we can do
        #       @person.activities(viewer_id: current_user.id)

        activities = stream(person:)

        render :index, locals: { activities:,
                                 person:,
                                 title: person.display_name }
      end

      private

      def stream(person:)
        return @stream if defined?(@stream)

        @stream = Activity.person_stream(actor_uid: person.id,
                                         viewer_id: current_user.id).decorate
      end
    end
  end
end
