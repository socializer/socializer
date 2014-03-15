module Socializer
  class AudiencesController < ApplicationController
    before_action :authenticate_user!

    def index
      people  = []
      circles = current_user.circles
      groups  = current_user.groups

      query = params.fetch(:q) { nil }

      if query.present? && query.size > 0
        query_value = "%#{query}%"

        people  = Person.where { display_name.like query_value }
        circles = circles.where { name.like query_value }
        groups  = groups.where { name.like query_value }
      end

      privacy_level         = Socializer::Audience.privacy_level
      privacy_level_public  = privacy_level.find_value(:public)
      privacy_level_circles = privacy_level.find_value(:circles)

      audiences = [id: privacy_level_public.value, name: privacy_level_public.text] +
                  [id: privacy_level_circles.value, name: privacy_level_circles.text] +
                  people.map { |person| { id: person.guid, name: person.display_name } } +
                  circles.map { |circle| { id: circle.guid, name: circle.name } } +
                  groups.map { |group| { id: group.guid, name: group.name } }

      respond_to do |format|
        format.json { render json: audiences }
      end
    end
  end
end
