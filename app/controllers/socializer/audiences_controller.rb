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
      people  = query.blank? ? [] : person_audience_list_query(query)
      circles = circles_audience_list_query(current_user, query)
      groups  = groups_audience_list_query(current_user, query)

      build_audience_list_array(OpenStruct.new(people: people, circles: circles, groups: groups))
    end

    def person_audience_list_query(query)
      return if query.blank?
      @people ||= Person.select(:display_name).guids.where(Person.arel_table[:display_name].matches("%#{query}%"))
    end

    def circles_audience_list_query(current_user, query)
      @circles ||= current_user.circles.select(:name).guids
      return @circles if query.blank?
      @circles ||= @circles.where(Circle.arel_table[:name].matches("%#{query}%"))
    end

    def groups_audience_list_query(current_user, query)
      @groups ||= current_user.groups.select(:name).guids
      return @groups if query.blank?
      @groups  ||= @groups.where(Group.arel_table[:name].matches("%#{query}%"))
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
