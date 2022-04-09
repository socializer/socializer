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
        # TODO: Need to add some validations for required params

        # Initializer
        #
        # @param [Socializer::Person] actor: the person sharing the activity
        def initialize(actor:)
          @actor_guid = actor.guid
        end

        # Creates the [Socializer::Activity]
        #
        # @param [ActionController::Parameters] params: the share parameters
        # from the request
        #
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

        def parse_params(params:)
          @activity_object_id = params[:activity_id]
          @content = params[:content]
          @object_ids = params[:object_ids].split(",")
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
