#
# Namespace for the Socializer engine
#
module Socializer
  class AudiencesController < ApplicationController
    before_action :authenticate_user!

    def index
      query     = params.fetch(:q) { nil }
      audiences = AudienceList.perform(person: current_user, query: query)

      respond_to do |format|
        format.json { render json: audiences }
      end
    end
  end
end
