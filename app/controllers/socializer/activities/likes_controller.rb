# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for activity-related controllers
  #
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
        Activity::Services::Like.new(actor: current_user)
                                .call(activity_object: find_likable)

        respond_to do |format|
          format.js do
            render :create, locals: { activity: find_activity }
          end
        end
      end

      # DELETE /activities/1/unlike
      def destroy
        Activity::Services::Unlike.new(actor: current_user)
                                  .call(activity_object: find_likable)

        respond_to do |format|
          format.js do
            render :destroy, locals: { activity: find_activity }
          end
        end
      end

      private

      def find_likable
        return @find_likable if defined?(@find_likable)

        @find_likable = ActivityObject.find_by(id: params[:id])
      end

      def find_activity
        return @find_activity if defined?(@find_activity)

        @find_activity = find_likable.activitable.decorate
      end

      # Never trust parameters from the scary internet, only allow the white
      # list through.
      # def like_params
      #   params.require(:like).permit(:actor_id, :activity_object_id)
      # end
    end
  end
end
