# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  module Activities
    #
    # Likes controller
    #
    class LikesController < ApplicationController
      before_action :authenticate_user

      # GET /activities/1/likes
      # Get a list of people who like the activity
      def index
        activity = Activity.find_by(id: params[:id])

        @people = activity.activity_object.liked_by

        respond_to do |format|
          format.html { render layout: false if request.xhr? }
        end
      end

      # POST /activities/1/like
      def create
        like = Activity::Services::Like.new(actor: current_user)
        like.call(activity_object: find_likable) do |result|
          result.success do |activity|
            respond_to do |format|
              format.js do
                activity = activity[:activity_object].activitable.decorate
                render :create, locals: { activity: activity }
              end
            end
          end

          result.failure :validate do |errors|
            @errors = errors
          end
        end
      end

      # DELETE /activities/1/unlike
      def destroy
        unlike = Activity::Services::Unlike.new(actor: current_user)
        unlike.call(activity_object: find_likable) do |result|
          result.success do |activity|
            respond_to do |format|
              format.js do
                activity = activity[:activity_object].activitable.decorate
                render :destroy, locals: { activity: activity }
              end
            end
          end

          result.failure :validate do |errors|
            @errors = errors
          end
        end
      end

      private

      def find_likable
        @find_likable ||= ActivityObject.find_by(id: like_params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white
      # list through.
      def like_params
        # params.require(:like).permit(:actor_id, :activity_object_id)

        like_params = params.to_unsafe_hash.symbolize_keys.clone
        like_params.delete_if { |key, _value| key != :id }

        like_params
      end
    end
  end
end
