# frozen_string_literal: true

# REMOVE: Delete this file

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
          contract = Activity::Contract::Share.new
          @params  = params
          @result  = contract.call(share_attributes)

          if result.success?
            Socializer::CreateActivity.new(result.to_h).call
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

        def validation_errors
          @activity = Activity.new

          result.errors.to_h.each do |key, value|
            activity.errors.add(key, value)
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
