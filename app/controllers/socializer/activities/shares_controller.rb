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
        share = Activity::Operations::Share.new(actor: current_user)
        result = share.call(params: share_params)
        notice = result.success[:notice] if result.success?

        return redirect_to activities_path, notice: notice if result.success?

        create_failure(failure: result.failure)
      end

      private

      def create_failure(failure:)
        # @activity = Activity.new
        @errors = failure.errors.to_h
        activity_object = find_activity_object(id: params[:activity_id])

        render :new, locals: { activity_object: activity_object,
                               share: share_params }
      end

      # TODO: Add to ActivityObject
      def find_activity_object(id:)
        @find_activity_object ||= ActivityObject.find_by(id: id)
      end

      # Only allow a trusted parameter "white list" through.
      def share_params
        # params.require(:share).permit(:activity_id, :content, :object_ids)

        params[:share].to_unsafe_hash.symbolize_keys.clone
      end
    end
  end
end
