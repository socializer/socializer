#
# Namespace for the Socializer engine
#
module Socializer
  class AudienceListsController < ApplicationController
    before_action :authenticate_user

    # GET /audience_lists
    def index
      query     = params.fetch(:q) { nil }
      audiences = AudienceList.perform(person: current_user, query: query)

      respond_to do |format|
        format.json { render json: audiences }
      end
    end
  end
end
