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
            render :new, locals: { activity_object: activity_object,
                                   share: share }
          end
        end
      end

      # POST /activities/1/share
      def create
        activity_object = find_activity_object(id: share_params[:activity_id])

        transaction = Activity::Transactions::Share.new
        transaction.call(share_params) do |result|
          result.success do |share|
            redirect_to activities_path, notice: share[:notice]
          end

          result.failure :validate do |errors|
            @activity = Activity.new
            @errors = errors
            render :new, locals: { activity_object: activity_object,
                                   share: share_params }
          end
        end
      end

      private

      # TODO: Add to ActivityObject
      def find_activity_object(id:)
        @find_activity_object ||= ActivityObject.find_by(id: id)
      end

      # Only allow a trusted parameter "white list" through.
      def share_params
        # params.require(:share).permit(:activity_id, :content, :object_ids)

        share_params = params[:share].to_unsafe_hash.symbolize_keys.clone
        share_params[:actor_id] = current_user.guid

        share_params
      end
    end
  end
end
