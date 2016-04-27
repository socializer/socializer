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
        PUBLIC = Audience.privacy.public.value.freeze

        # Initializer
        #
        # @param [Socializer::Person] actor: the person that likes the activity
        # @param [Fixnum] activity_object_id: the id for the
        # [Socializer::ActivityObject]
        def initialize(actor:, activity_object:)
          @actor = actor
          @activity_object = activity_object
          # @verb = Verb.find_or_create_by(display_name: verb)
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

        def change_like_count
          @activity_object.increment!(:like_count)
        end

        def blocked?
          @actor.likes?(@activity_object)
        end

        def verb
          "like"
        end
      end
    end
  end
end
