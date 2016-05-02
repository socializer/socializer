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
      # Service object for unliking a Socializer::Activity
      #
      # @example
      #   ActivityObject::Services::Unlike.new(actor: current_user,
      #                                        activity_object: @likable).call
      class Unlike < Like
        private

        def change_like_count
          @activity_object.decrement!(:like_count)
        end

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
