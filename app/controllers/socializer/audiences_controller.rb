module Socializer
  class AudiencesController < ApplicationController
    before_action :authenticate_user!

    def index
      query     = params.fetch(:q) { nil }

      people  = []
      circles = current_user.circles.select(:name).guids
      groups  = current_user.groups.select(:name).guids

      if query.present? && query.size > 0
        query_value = "%#{query}%"

        people  = Person.select(:display_name).guids.where { display_name.like(query_value) }
        circles = circles.where { name.like(query_value) }
        groups  = groups.where { name.like(query_value) }
      end

      privacy_level         = Socializer::Audience.privacy_level
      privacy_level_public  = privacy_level.find_value(:public)
      privacy_level_circles = rivacy_level.find_value(:circles)

      privacy_public  = { id: privacy_level_public.value, name: privacy_level_public.text }
      privacy_circles = { id: privacy_level_circles.value, name: privacy_level_circles.text }

      audiences = []

      audiences << privacy_public
      audiences << privacy_circles
      audiences.concat(people)
      audiences.concat(circles)
      audiences.concat(groups)

      respond_to do |format|
        format.json { render json: audiences }
      end
    end
  end
end
