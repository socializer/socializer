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
      # Service object for unliking a Socializer::Activity
      #
      # @example
      #   Activity::Services::Unlike.new(actor: current_user,
      #                                  activity_object: @likable).call
      class Unlike < Like
        private

        # Decrement the like_count for the [Socializer::ActivityObject]
        #
        # @return [TrueClass, FalseClass] returns true if the record could
        # be saved
        def change_like_count
          @activity_object.decrement!(:like_count)
        end

        # Return true if creating the [Socializer::Activity] shoud not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          !@actor.likes?(@activity_object)
        end

        # The verb to use when unliking an [Socializer::ActivityObject]
        #
        # @return [String]
        #
        def verb
          "unlike"
        end
      end
    end
  end
end
