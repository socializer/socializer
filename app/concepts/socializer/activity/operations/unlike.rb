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
    # Namespace for Operation related objects
    #
    module Operations
      #
      # Service object for unliking a Socializer::Activity
      #
      # @example
      #   Activity::Operations::Unlike.new(actor: current_user)
      #                             .call(activity_object: @likable)
      class Unlike < Like
        private

        # Decrement the like_count for the [Socializer::ActivityObject]
        #
        # @return [TrueClass, FalseClass] returns true if the record could
        # be saved
        def change_like_count
          result = activity_object.decrement(:like_count).save

          result ? Success(result) : Failure(result)
        end

        # Return true if creating the [Socializer::Activity] shoud not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          !actor.likes?(activity_object)
        end

        # Returns an instance of the Socializer::Activity::Contracts::Unlike
        # class
        #
        #  @return [Socializer::Activity::Contracts::Unlike]
        def contract
          @contract ||= Activity::Contracts::Unlike.new
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