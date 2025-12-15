# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for activity-related controllers
  #
  module Activities
    # Shares controller
    class SharesController < ApplicationController
      before_action :authenticate_user

      # GET /activities/1/share
      def new
        activity_object = find_activity_object(id: params[:id])
        share = activity_object.activitable

        respond_to do |format|
          format.html do
            render :new, locals: { activity_object:, share: }
          end
        end
      end

      # POST /activities/1/share
      def create
        activity_object = find_activity_object(id: share_params[:activity_id])

        # TODO: Need a validator to validate params - dry-validation
        # TODO: Pass the validator into the service
        activity = Activity::Services::Share.new(actor: current_user)
                                            .call(params: share_params)

        if activity.persisted?
          notice = flash_message(action: :create, activity_object:)

          redirect_to activities_path, notice:
        else
          render :new, locals: { activity_object:, share: share_params }
        end
      end

      private

      # TODO: Add to ActivityObject
      # Finds and memoizes an ActivityObject by id.
      #
      # @param id [Integer, String] The id of the ActivityObject to look up.
      #
      # @return [ActivityObject, nil] The found ActivityObject or +nil+ if none exists.
      #
      # @example
      #   # Given an ActivityObject with id 1
      #   find_activity_object(id: 1) # => #<ActivityObject id: 1 ...>
      def find_activity_object(id:)
        return @find_activity_object if defined?(@find_activity_object)

        @find_activity_object = ActivityObject.find_by(id:)
      end

      # Returns a localized flash message for the given action and activity object.
      #
      # @param action [Symbol] The action key used for translation lookup (e.g. :create, :update).
      # @param activity_object [#decorate] The activity object which responds to `decorate` and `demodulized_type`.
      #
      # @return [String] The translated flash message.
      #
      # @example
      #   activity_object = ActivityObject.find(1)
      #   flash[:notice] = flash_message(action: :create, activity_object: activity_object)
      def flash_message(action:, activity_object:)
        t("socializer.model.#{action}",
          model: activity_object.decorate.demodulized_type)
      end

      # Returns the permitted parameters for creating a Share activity.
      # Uses strong parameter expectations to require the `share` top-level key
      # and permit the `activity_id`, `content` and `object_ids` fields.
      #
      # @return [ActionController::Parameters] filtered parameters for the Share service.
      #
      # @example
      #   # Given params:
      #   # { share: { activity_id: "1", content: "Hi", object_ids: ["2","3"] } }
      #   # this method will return an ActionController::Parameters containing those keys.
      def share_params
        params.expect(share: %i[activity_id content object_ids])
      end
    end
  end
end
