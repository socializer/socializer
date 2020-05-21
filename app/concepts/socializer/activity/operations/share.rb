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
      # Service object for sharing a Socializer::Activity
      #
      # @example
      #   share = Activity::Operations::Share.new(actor: current_user)
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
      class Share < Base::Operation
        # Initializer
        #
        extend Dry::Initializer

        # Adds the actor keyword argument to the initializer, ensures the tyoe
        # is [Socializer::Person], and creates a private reader
        option :actor, type: Types.Strict(Person), reader: :private

        # Creates the [Socializer::Activity]
        #
        # @param [Hash] params: the share parameters
        # from the request
        #
        # @return [Socializer::Activity]
        def call(params:)
          validated = yield validate(share_params(params: params))
          activity = yield create(validated.to_h)

          notice = yield success_message(activity: activity)

          Success(activity: activity, notice: notice)
        end

        private

        def validate(params)
          contract = Activity::Contracts::Share.new
          contract.call(params).to_monad
        end

        def create(params)
          activity = Activity::Operations::Create.new(actor: actor)
          activity.call(params: params)
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
