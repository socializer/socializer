module Socializer
  class SharesController < ApplicationController

    def new
      @activity_object = ActivityObject.find(params[:id])
      @share = @activity_object.activitable
    end

    def create
      activity_object = ActivityObject.find(params[:share][:activity_id])
      activity_object.share!(current_user.guid, params[:share][:object_ids], params[:share][:content])
      redirect_to stream_path
    end

  end
end
