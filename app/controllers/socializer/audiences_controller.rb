module Socializer
  class AudiencesController < ApplicationController

    def index
      
      if !params[:q].nil? && params[:q].size > 0
        @people = Person.where("display_name LIKE '%" + params[:q] + "%'")
        @circles = current_user.circles.where("name LIKE '%" + params[:q] + "%'")
        @groups = current_user.groups.where("name LIKE '%" + params[:q] + "%'")
      else
        @people = []
        @circles = current_user.circles
        @groups = current_user.groups
      end
      
      @audiences = ["id" => "PUBLIC", "name" => "Public"] +
                   ["id" => "CIRCLES", "name" => "Your circles"] + 
                   @people.collect{ |x| {"id" => x.guid, "name" => x.display_name} } + 
                   @circles.collect{ |x| {"id" => x.guid, "name" => x.name} } +
                   @groups.collect{ |x| {"id" => x.guid, "name" => x.name} }
                    
      
      respond_to do |format|
        format.json { render :json => @audiences }
      end
      
    end
  
  end
end
