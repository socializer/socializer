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
      # Service object for sharing a Socializer::Activity
      #
      # @example
      #   share = Activity::Services::Share.new(actor: current_user)
      #   share.call(params: share_params) do |result|
      #     result.success do |activity|
      #       redirect_to activities_path, notice: activity[:notice]
      #     end
      #
      #     result.failure do |failure|
      #       @activity = failure[:share]
      #       @errors = failure[:errors]
      #       activity_object = find_activity_object(id: params[:activity_id])
      #
      #       render :new, locals: { activity_object: activity_object,
      #                              share: share_params }
      #     end
      #   end
      class Share
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
        # @param [ActionController::Parameters] params: the share parameters
        # from the request
        #
        # @return [Socializer::Activity]
        def call(params:)
          validated = yield validate(share_params(params: params))
          activity = yield create(validated)

          if activity.persisted?
            notice = yield success_message(activity: activity)

            return Success(activity: activity, notice: notice)
          end

          # TODO: Should this use validation errors?
          Failure(activity: activity)
        end

        private

        def validate(params)
          contract = Activity::Contracts::Share.new
          result = contract.call(params)

          if result.success?
            Success(result)
          else
            # result.errors
            # result.errors(full: true).values
            # TODO: Should this use validation errors?
            Failure(activity: Activity.new, errors: result.errors.to_h)
          end
        end

        def create(params)
          activity = Activity::Services::Create.new(actor: actor)
          activity.call(params: params.to_h) do |result|
            result.success do |success|
              Success(success[:activity])
            end

            result.failure do |failure|
              Failure(failure[:activity])
            end
          end
        end

        def share_params(params:)
          share_params = { actor_id: actor.guid,
                           activity_object_id: params[:activity_id],
                           verb: verb }

          params.merge(share_params)
        end

        def success_message(activity:)
          activity_object = activity.activitable_object
          model = activity_object.activitable_type.demodulize
          notice = I18n.t("socializer.model.share", model: model)

          Success(notice)
        end

        # def validation_errors
        #   @activity = Activity.new

        #   result.errors.to_h.each do |key, value|
        #     activity.errors.add(key, value)
        #   end

        #   activity
        # end

        # The verb to use when sharing an [Socializer::ActivityObject]
        #
        # @return [String]
        def verb
          "share"
        end
      end
    end
  end
end
