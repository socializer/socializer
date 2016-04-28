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
        @activity_object = find_activity_object(id: params[:id])
        @share = @activity_object.activitable
      end

      # POST /activities/1/share
      def create
        share = params[:share]
        activity_object = find_activity_object(id: share[:activity_id])

        ActivityObject::Services::Share
          .new(actor: current_user,
               activity_object: activity_object,
               object_ids: share[:object_ids].split(","),
               content: share[:content]).call

        flash[:notice] = flash_message(action: :create,
                                       activity_object: activity_object)

        redirect_to activities_path
      end

      private

      # TODO: Add to ActivityObject
      def find_activity_object(id:)
        @find_activity_object ||= ActivityObject.find_by(id: id)
      end

      def flash_message(action:, activity_object:)
        t("socializer.model.#{action}",
          model: activity_object.decorate.demodulized_type)
      end
    end
  end
end
