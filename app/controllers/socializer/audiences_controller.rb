module Socializer
  class AudiencesController < ApplicationController
    before_action :authenticate_user!

    def index
      query   = params.fetch(:q) { nil }
      results = user_audience_list(current_user, query)

      audiences = []

      audiences << Audience.privacy_level_hash(:public)
      audiences << Audience.privacy_level_hash(:circles)
      audiences.concat(results.people)
      audiences.concat(results.circles)
      audiences.concat(results.groups)

      respond_to do |format|
        format.json { render json: audiences }
      end
    end

    private

    def user_audience_list(current_user, query)
      people  = []
      circles = current_user.circles.select(:name).guids
      groups  = current_user.groups.select(:name).guids

      if query.present? && query.size > 0
        query_value = "%#{query}%"

        person_name = Person.arel_table[:display_name]
        circle_name = Circle.arel_table[:name]
        group_name  = Group.arel_table[:name]

        people  = Person.select(:display_name).guids.where(person_name.matches(query_value))
        circles = circles.where(circle_name.matches(query_value))
        groups  = groups.where(group_name.matches(query_value))
        # people  = Person.select(:display_name).guids.where { display_name.like(query_value) }
        # circles = circles.where { name.like(query_value) }
        # groups  = groups.where { name.like(query_value) }
      end

      OpenStruct.new(people: people, circles: circles, groups: groups)
    end
  end
end
