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
          Socializer::CreateActivity.new(validate_params(params: params)).call
        end

        private

        def validate_params(params:)
          result = Activity::Contract::Share.call(params)

          share_attributes(attributes: result.output)
        end

        def share_attributes(attributes:)
          { actor_id: actor.guid,
            activity_object_id: attributes[:activity_id],
            verb: verb,
            object_ids: attributes[:object_ids],
            content: attributes[:content] }
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
