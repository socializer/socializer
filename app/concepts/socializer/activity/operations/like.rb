# frozen_string_literal: true

require "dry/initializer"

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
      # Service object for liking a Socializer::Activity
      #
      # @example
      #   like = Activity::Operations::Like.new(actor: current_user)
      #   like.call(params: like_params) do |result|
      #     result.success do |activity|
      #     end
      #
      #     result.failure do |failure|
      #     end
      #   end
      class Like < Base::Operation
        PUBLIC = Socializer::Audience.privacy.public.value.freeze

        # Initializer
        #
        extend Dry::Initializer

        # Adds the actor keyword argument to the initializer, ensures the type
        # is [Socializer::Person], and creates a private reader
        option :actor, type: Types.Strict(Person), reader: :private

        # Creates the [Socializer::Activity]
        #
        # @param [Socializer::ActivityObject] activity_object: the
        # Socializer::ActivityObject being liked
        #
        # @return [Dry::Monads::Result::Success] or
        # [Dry::Monads::Result::Failure]
        def call(activity_object:)
          @activity_object = activity_object

          return Failure(Socializer::Activity.none) if blocked?

          validated = yield validate(like_params)
          activity = yield create(validated.to_h)

          Success(activity: activity, activity_object: activity_object)
        end

        private

        attr_reader :activity_object

        def validate(params)
          contract.call(params).to_monad
        end

        def create(params)
          ActiveRecord::Base.transaction do
            activity = Activity::Operations::Create.new(actor: actor)
            result = yield activity.call(params: params)

            yield change_like_count

            Success(result)
          end
        end

        def like_params
          { actor_id: actor.guid,
            activity_object_id: activity_object.id,
            object_ids: PUBLIC,
            verb: verb }
        end

        # Return true if creating the [Socializer::Activity] should not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          actor.likes?(activity_object)
        end

        # Returns an instance of the Socializer::Activity::Contracts::Like
        # class
        #
        #  @return [Socializer::Activity::Contracts::Like]
        def contract
          @contract ||= Activity::Contracts::Like.new
        end

        # Increment the like_count for the [Socializer::ActivityObject]
        #
        # @return [TrueClass, FalseClass] returns true if the record could
        # be saved
        def change_like_count
          result = activity_object.increment(:like_count).save

          result ? Success(result) : Failure(result)
        end

        # The verb to use when liking an [Socializer::ActivityObject]
        #
        # @return [String]
        def verb
          Types::ActivityVerbs["like"]
        end
      end
    end
  end
end
