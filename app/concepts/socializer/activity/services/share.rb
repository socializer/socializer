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
      #   Activity::Services::Share.new(actor: current_user,
      #                                 params: params[:share]).call
      class Share
        # Initializer
        #
        # @param [Socializer::Person] actor: the person sharing the activity
        # @param [ActionController::Parameters] params: the share parameters
        # from the request
        def initialize(actor:, params:)
          @actor_guid = actor.guid
          @activity_object_id = params[:activity_id]
          @content = params[:content]
          @object_ids = params[:object_ids].split(",")
        end

        # Creates the [Socializer::Activity]
        #
        # @return [Socializer::Activity]
        def call
          Socializer::CreateActivity
            .new(actor_id: @actor_guid,
                 activity_object_id: @activity_object_id,
                 verb: verb,
                 object_ids: @object_ids,
                 content: @content).call
        end

        private

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
