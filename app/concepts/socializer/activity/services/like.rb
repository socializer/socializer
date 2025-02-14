# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class Activity
    #
    # Namespace for Service related objects
    #
    module Services
      #
      # Service object for liking a Socializer::Activity
      #
      # @example
      #   Activity::Services::Like.new(actor: current_user)
      #                           .call(activity_object: @likable)
      class Like
        # Initializer
        #
        # @param actor [Socializer::Person] the person that likes the activity
        def initialize(actor:)
          @actor = actor
        end

        # Creates the [Socializer::Activity]
        #
        # @param activity_object [Socializer::ActivityObject] the
        #   Socialicer::ActivityObject being liked
        #
        # @return [Socializer::Activity]
        def call(activity_object:)
          @activity_object = activity_object

          return Socializer::Activity.none if blocked?

          activity = create_activity
          change_like_count # if activity.present?
          activity
        end

        private

        attr_reader :actor, :activity_object

        def create_activity
          Socializer::CreateActivity
            .new(actor_id: actor.guid,
                 activity_object_id: activity_object.id,
                 verb:,
                 object_ids: Socializer::Audience::PUBLIC_PRIVACY).call
        end

        # Increment the like_count for the [Socializer::ActivityObject]
        #
        # @return [TrueClass, FalseClass] returns true if the record could
        # be saved
        def change_like_count
          activity_object.increment(:like_count).save
        end

        # Return true if creating the [Socializer::Activity] shoud not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          actor.likes?(activity_object)
        end

        # The verb to use when liking an [Socializer::ActivityObject]
        #
        # @return [String]
        def verb
          "like"
        end
      end
    end
  end
end
