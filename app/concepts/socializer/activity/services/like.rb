# frozen_string_literal: true

require "dry-initializer"
require "dry/monads/result"
require "dry/monads/do/all"
require "dry/matcher/result_matcher"

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
      #   like = Activity::Services::Like.new(actor: current_user)
      #   like.call(params: like_params) do |result|
      #     result.success do |activity|
      #     end
      #
      #     result.failure do |failure|
      #     end
      #   end
      class Like
        PUBLIC = Socializer::Audience.privacy.public.value.freeze

        # Initializer
        #
        extend Dry::Initializer

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do::All
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

        # Adds the actor keyword argument to the initializer, ensures the tyoe
        # is [Socializer::Person], and creates a private reader
        option :actor, Dry::Types["any"].constrained(type: Person),
               reader: :private

        # Creates the [Socializer::Activity]
        #
        # @param [Socialicer::ActivityObject] activity_object: the
        # Socialicer::ActivityObject being liked
        #
        # @return [Socializer::Activity]
        def call(activity_object:)
          @activity_object = activity_object

          return Failure(Socializer::Activity.none) if blocked?

          validated = yield validate(like_params)
          activity = yield create(validated)

          return Success(activity: activity) if activity.persisted?

          Failure(activity)
          # activity = create_activity
          # change_like_count # if activity.present?
          # activity
        end

        private

        attr_reader :activity_object

        def validate(params)
          result = contract.call(params)

          if result.success?
            Success(result)
          else
            # Failure(result.errors)
            Failure(activity: Activity.new, errors: result.errors.to_h)
          end
        end

        def create(params)
          ActiveRecord::Base.transaction do
            activity = Socializer::CreateActivity.new(params.to_h).call
            change_like_count

            if activity.persisted?
              Success(activity)
            else
              Failure(activity)
              raise ActiveRecord::Rollback
            end
          end
        end

        def like_params
          like_params = { actor_id: actor.guid,
                          activity_object_id: activity_object.id,
                          object_ids: PUBLIC,
                          verb: verb }

          like_params
        end

        # Return true if creating the [Socializer::Activity] shoud not proceed
        #
        # @return [TrueClass, FalseClass]
        def blocked?
          actor.likes?(activity_object)
        end

        def contract
          contract ||= Activity::Contracts::Like.new
        end

        # Increment the like_count for the [Socializer::ActivityObject]
        #
        # @return [TrueClass, FalseClass] returns true if the record could
        # be saved
        def change_like_count
          activity_object.increment(:like_count).save
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
