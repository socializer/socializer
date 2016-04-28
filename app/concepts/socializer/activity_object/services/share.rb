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
      # Service object for sharing a Socializer::Activity
      #
      class Share
        def initialize(actor:, activity_object:, object_ids:, content: nil)
          @actor = actor
          @activity_object = activity_object
          @content = content
          @object_ids = object_ids
        end

        # Creates the [Socializer::Activity]
        #
        # @return [Socializer::Activity]
        def call
          # ActiveRecord::Base.transaction do
          # raise ActiveRecord::Rollback
          # end
          Socializer::CreateActivity
            .new(actor_id: @actor.guid,
                 activity_object_id: @activity_object.id,
                 verb: verb,
                 object_ids: @object_ids,
                 content: @content).call
        end

        private

        def verb
          "share"
        end
      end
    end
  end
end
