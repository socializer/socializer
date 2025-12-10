# frozen_string_literal: true

# Namespace for the Socializer engine
module Socializer
  # Namespace for Activity-related objects.
  class Activity
    # Namespace for Service-related objects.
    module Services
      # Service object for liking a Socializer::Activity
      #
      # @example
      #   Activity::Services::Like.new(actor: current_user)
      #                           .call(activity_object: @likable)
      class Like
        # Initializer
        # @param actor [Socializer::Person] the person that likes the activity
        def initialize(actor:)
          @actor = actor
        end

        # Creates the [Socializer::Activity]
        #
        # @param activity_object [Socializer::ActivityObject] the
        #   Socializer::ActivityObject being liked
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

        # Creates and persists a "like" Activity for the current +actor+ and
        # +activity_object+. Delegates creation to +Socializer::CreateActivity+
        # with the +like+ verb and public audience.
        #
        # @return [Array, Socializer::Activity] the created activity (or an AR relation/none)
        #
        # @example
        #   # Called internally by Activity::Services::Like#call
        #   create_activity
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

        # Return true if creating the [Socializer::Activity] should not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          actor.likes?(activity_object)
        end

        # The verb to use when liking a [Socializer::ActivityObject]
        #
        # @return [String]
        def verb
          "like"
        end
      end
    end
  end
end
