# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  module Activities
    #
    # Shares controller
    #
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
      def find_activity_object(id:)
        @find_activity_object ||= ActivityObject.find_by(id:)
      end

      def flash_message(action:, activity_object:)
        t("socializer.model.#{action}",
          model: activity_object.decorate.demodulized_type)
      end

      # Only allow a list of trusted parameters through.
      def share_params
        params.require(:share).permit(:activity_id, :content, :object_ids)
      end
    end
  end
end
