module Socializer
  class PersonPlacesController < ApplicationController
    def create
      @person_place = current_user.adresses.build(params[:person_place])
      @person_place.save!
      redirect_to current_user
    end

    def update
      @person_place = current_user.places.find(params[:id])
      @person_place.update!(params[:person_place])
      redirect_to current_user
    end

    def destroy
      @person_place = current_user.places.find(params[:id])
      @person_place.destroy
      redirect_to current_user
    end
  end
end
