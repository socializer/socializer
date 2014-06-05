module Socializer
  class AudiencesController < ApplicationController
    before_action :authenticate_user!

    def index
      query     = params.fetch(:q) { nil }
      audiences = user_audience_list(current_user, query)

      respond_to do |format|
        format.json { render json: audiences }
      end
    end

    private

    def user_audience_list(current_user, query)
      people  = query.blank? ? [] : Person.audience_list(query)
      circles = Circle.audience_list(current_user, query)
      groups  = Group.audience_list(current_user, query)

      build_audience_list_array(OpenStruct.new(people: people, circles: circles, groups: groups))
    end

    def build_audience_list_array(audience_list)
      audiences = []

      audiences << Audience.privacy_level_hash(:public)
      audiences << Audience.privacy_level_hash(:circles)
      audiences.concat(audience_list.people)
      audiences.concat(audience_list.circles)
      audiences.concat(audience_list.groups)
    end
  end
end
