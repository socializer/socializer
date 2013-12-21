module Socializer
  class AudiencesController < ApplicationController
    def index
      if params[:q].present? && params[:q].size > 0
        query_value = "%#{params[:q]}%"

        @people = Person.where{display_name.like query_value}
        @circles = current_user.circles.where{name.like query_value}
        @groups = current_user.groups.where{name.like query_value}
      else
        @people = []
        @circles = current_user.circles
        @groups = current_user.groups
      end

      public  = Socializer::Audience.privacy_level.find_value(:public)
      circles = Socializer::Audience.privacy_level.find_value(:circles)

      @audiences = [id: public.value, name: public.text] +
                   [id: circles.value, name: circles.text] +
                   @people.collect{ |x| {id: x.guid, name: x.display_name} } +
                   @circles.collect{ |x| {id: x.guid, name: x.name} } +
                   @groups.collect{ |x| {id: x.guid, name: x.name} }

      respond_to do |format|
        format.json { render json: @audiences }
      end
    end
  end
end
