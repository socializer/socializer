module Socializer
  class PeopleController < ApplicationController
    
    def index
      @people = Person.all
    end
  
    def show
      @person = Person.find(params[:id])
    end
  
    def edit
      @person = current_user
    end
  
    def update
      current_user.update_attributes!(params[:person])
      redirect_to current_user
    end
  
  end
end
