# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for Activity-related objects
  class Activity
    # Namespace for Service-related objects
    module Services
      # Service object for unliking a Socializer::Activity
      #
      # @example
      #   Activity::Services::Unlike.new(actor: current_user)
      #                             .call(activity_object: @likable)
      class Unlike < Like
        private

        # Decrement the like_count for the [Socializer::ActivityObject]
        #
        # @return [TrueClass, FalseClass] returns true if the record could
        # be saved
        def change_like_count
          activity_object.decrement(:like_count).save
        end

        # Return true if creating the [Socializer::Activity] should not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          !actor.likes?(activity_object)
        end

        # Return the action verb for this service.
        #
        # @return [String] the verb describing the operation performed by this service.
        #
        # @example
        #   service = Activity::Services::Unlike.new(actor: current_user)
        #   service.verb #=> "unlike"
        def verb
          "unlike"
        end
      end
    end
  end
end
