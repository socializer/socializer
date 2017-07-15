# frozen_string_literal: true

require "dry-initializer"

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
      #   Activity::Services::Share.new(actor: current_user)
      #                            .call(params: params[:share])
      class Share
        # Initializer
        #
        extend Dry::Initializer

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
          @params = params
          @result = Activity::Contract::Share.call(share_attributes)

          if result.success?
            Socializer::CreateActivity.new(result.output).call
          else
            validation_errors
          end
        end

        private

        attr_reader :activity, :params, :result

        # TODO: Should this be a dry-struct?
        def share_attributes
          { actor_id: actor.guid,
            activity_object_id: params[:activity_id],
            verb: verb,
            object_ids: params[:object_ids],
            content: params[:content] }
        end

        def add_errors_to_activity(field:, messages:)
          messages.each do |message|
            activity.errors.add(field, message)
          end
        end

        def validation_errors
          @activity = Activity.new

          result.messages.each do |field, messages|
            add_errors_to_activity(field: field, messages: messages)
          end

          activity
        end

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
