module Socializer
  class AudiencesController < ApplicationController

    def index
      
      if !params[:q].nil? && params[:q].size > 0
        @people = Person.where("display_name LIKE '%" + params[:q] + "%'")
        @circles = Circle.where("name LIKE '%" + params[:q] + "%'")
        @groups = Group.where("name LIKE '%" + params[:q] + "%'")
      else
        @people = []
        @circles = []
        @groups = []
      end
      
      @audiences = ["id" => "PUBLIC", "name" => "Public"] +
                   ["id" => "CIRCLES", "name" => "Circles"] + 
                   @people.collect{ |x| {"id" => x.guid, "name" => x.display_name} } + 
                   @circles.collect{ |x| {"id" => x.guid, "name" => x.name} } +
                   @groups.collect{ |x| {"id" => x.guid, "name" => x.name} }
                    
      
      respond_to do |format|
        format.json { render :json => @audiences }
      end
      
    end
  
  end
end
