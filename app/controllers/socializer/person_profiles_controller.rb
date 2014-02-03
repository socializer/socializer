module Socializer
  class PersonProfilesController < ApplicationController
    def create
      @person_profile = current_user.adresses.build(params[:person_profile])
      @person_profile.save!
      redirect_to current_user
    end

    def update
      @person_profile = current_user.profiles.find(params[:id])
      @person_profile.update!(params[:person_profile])
      redirect_to current_user
    end

    def destroy
      @person_profile = current_user.profiles.find(params[:id])
      @person_profile.destroy
      redirect_to current_user
    end
  end
end
