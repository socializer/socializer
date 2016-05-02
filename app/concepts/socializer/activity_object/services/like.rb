# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class ActivityObject
    #
    # Namespace for Service related objects
    #
    module Services
      #
      # Service object for liking a Socializer::Activity
      #
      # @example
      #   ActivityObject::Services::Like.new(actor: current_user,
      #                                      activity_object: @likable).call
      class Like
        PUBLIC = Socializer::Audience.privacy.public.value.freeze

        # Initializer
        #
        # @param [Socializer::Person] actor: the person that likes the activity
        # @param [Socialicer::ActivityObject] activity_object: the
        # Socialicer::ActivityObject being liked
        def initialize(actor:, activity_object:)
          @actor = actor
          @activity_object = activity_object
        end

        # Creates the [Socializer::Activity]
        #
        # @return [Socializer::Activity]
        def call
          return Socializer::Activity.none if blocked?

          activity = create_activity
          change_like_count # if activity.present?
          activity
        end

        private

        def create_activity
          Socializer::CreateActivity
            .new(actor_id: @actor.guid,
                 activity_object_id: @activity_object.id,
                 verb: verb,
                 object_ids: PUBLIC).call
        end

        # Increment the like_count for the [Socializer::ActivityObject]
        #
        # @return [TrueClass, FalseClass] returns true if the record could
        # be saved
        def change_like_count
          @activity_object.increment!(:like_count)
        end

        # Return true if creating the [Socializer::Activity] shoud not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          @actor.likes?(@activity_object)
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
