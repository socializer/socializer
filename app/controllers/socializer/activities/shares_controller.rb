#
# Namespace for the Socializer engine
#
module Socializer
  module Activities
    class SharesController < ApplicationController
      before_action :authenticate_user

      def new
        @activity_object = ActivityObject.find_by(id: params[:id])
        @share = @activity_object.activitable
      end

      def create
        share = params[:share]
        activity_object = ActivityObject.find_by(id: share[:activity_id])
        activity_object.share!(actor_id: current_user.guid,
                               object_ids: share[:object_ids].split(','),
                               content: share[:content])

        flash[:notice] = t('socializer.model.share', model: activity_object.activitable_type.demodulize)
        redirect_to activities_path
      end
    end
  end
end
