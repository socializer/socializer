#
# Namespace for the Socializer engine
#
module Socializer
  class AudiencesController < ApplicationController
    before_action :authenticate_user!

    def index
      query     = params.fetch(:q) { nil }
      audiences = AudienceList.new(person: current_user, query: query).perform

      respond_to do |format|
        format.json { render json: audiences }
      end
    end
  end
end
