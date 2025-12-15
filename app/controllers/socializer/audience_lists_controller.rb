# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Audience Lists controller
  class AudienceListsController < ApplicationController
    before_action :authenticate_user

    # GET /audience_lists
    def index
      query = params.fetch(:q, nil)

      respond_to do |format|
        format.json do
          render json: AudienceList.call(person: current_user, query:)
        end
      end
    end
  end
end
