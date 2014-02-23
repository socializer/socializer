module Socializer
  class SharesController < ApplicationController
    before_action :authenticate_user!

    def new
      @activity_object = ActivityObject.find_by(id: params[:id])
      @share = @activity_object.activitable
    end

    def create
      activity_object = ActivityObject.find_by(id: params[:share][:activity_id])
      activity_object.share!(actor_id: current_user.guid,
                             object_ids: params[:share][:object_ids],
                             content: params[:share][:content])

      redirect_to stream_path
    end
  end
end
