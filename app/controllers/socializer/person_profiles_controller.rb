module Socializer
  class PersonProfilesController < ApplicationController
    before_filter :set_person_profile, only: [:update, :destroy]

    def create
      @person_profile = current_user.adresses.build(params[:person_profile])
      @person_profile.save!
      redirect_to current_user
    end

    def update
      @person_profile.update!(params[:person_profile])
      redirect_to current_user
    end

    def destroy
      @person_profile.destroy
      redirect_to current_user
    end

    private

    def set_person_profile
      @person_profile = current_user.profiles.find(params[:id])
    end
  end
end
