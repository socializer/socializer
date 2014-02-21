module Socializer
  class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_likable_and_activity, only: [:create, :destroy]

    # REFACTOR: should handle activity/tooltip as well as people likes
    # Used to display the Like tooltip
    def index
      activity = Activity.find(params[:id])
      @object_ids = []

      activity.activity_object.likes.each do |person|
        @object_ids.push person.activity_object
      end

      respond_to do |format|
        format.html { render layout: false if request.xhr? }
      end
    end

    def create
      @likable.like!(current_user) unless current_user.likes?(@likable)

      respond_to do |format|
        format.js
      end
    end

    def destroy
      @likable.unlike!(current_user) if current_user.likes?(@likable)

      respond_to do |format|
        format.js
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_likable_and_activity
      @likable = ActivityObject.find(params[:id])
      @activity = @likable.activitable.decorate
    end

    # # Never trust parameters from the scary internet, only allow the white list through.
    # def like_params
    #   params.require(:like).permit(:actor_id, :activity_object_id)
    # end
  end
end
