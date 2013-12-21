module Socializer
  class SharesController < ApplicationController
    # before_action :set_share, only: [:show, :edit, :update, :destroy]

    def new
      @activity_object = ActivityObject.find(params[:id])
      @share = @activity_object.activitable
    end

    def create
      scope = params[:share][:scope]
      object_ids = params[:share][:object_ids]

      activity = Activity.new do |a|
        a.actor_id           = current_user.guid
        a.activity_object_id = params[:share][:activity_id]
        a.verb               = Verb.find_or_create_by(name: 'share')
      end

      activity.build_activity_field(content: params[:share][:content]) if params[:share][:content]

      public  = Socializer::Audience.privacy_level.find_value(:public).value.to_s
      circles = Socializer::Audience.privacy_level.find_value(:circles).value.to_s

      object_ids.split(',').each do |object_id|
        # REFACTOR: remove duplication
        if object_id == public || object_id == circles
          activity.audiences.build(privacy_level: object_id)
        else
          activity.audiences.build do |a|
            a.privacy_level = :limited
            a.activity_object_id = object_id
          end
        end
      end

      activity.save!

      redirect_to stream_path
    end

    private
      # # Use callbacks to share common setup or constraints between actions.
      # def set_share
      #   @share = Share.find(params[:id])
      # end

      # # Never trust parameters from the scary internet, only allow the white list through.
      # def share_params
      #   params.require(:share).permit(:content, :actor_id)
      # end
  end
end
