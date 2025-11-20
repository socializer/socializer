# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity-related objects
  #
  class Activity
    #
    # Namespace for Service-related objects
    #
    module Services
      #
      # Service object for sharing a Socializer::Activity
      #
      # @example
      #   Activity::Services::Share.new(actor: current_user)
      #                            .call(params: params[:share])
      class Share
        # TODO: Need to add some validations for required params

        # Initializer
        #
        # @param actor [Socializer::Person] the person sharing the activity
        def initialize(actor:)
          @actor_guid = actor.guid
        end

        # Calls the service to create a new Socializer::Activity
        #
        # @param params [ActionController::Parameters] the share parameters
        # @return [Socializer::Activity]
        def call(params:)
          parse_params(params:)

          Socializer::CreateActivity
            .new(actor_id: actor_guid,
                 activity_object_id:,
                 verb:,
                 object_ids:,
                 content:).call
        end

        private

        attr_reader :actor_guid, :activity_object_id, :object_ids, :content

        # Parse share parameters and set instance variables used by the service.
        #
        # @param params [ActionController::Parameters, Hash] parameters for the share action.
        #   Expected keys:
        #     - :activity_id [String] the id of the activity being shared
        #     - :content [String, nil] optional text accompanying the share
        #     - :object_ids [String, Array<String>] comma-separated ids or array of ids to attach
        #
        # @return [void]
        #
        # @example
        #   # when called from controller
        #   parse_params(params: params[:share])
        def parse_params(params:)
          @activity_object_id = params[:activity_id]
          @content = params[:content]
          @object_ids = params[:object_ids].split(",")
        end

        # Returns the activity verb used when creating a shared activity.
        #
        # @return [String] the verb identifier for this service
        #
        # @example
        #   Activity::Services::Share.new(actor: person).send(:verb) # => "share"
        def verb
          "share"
        end
      end
    end
  end
end
