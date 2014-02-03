module Socializer
  class PersonEducationsController < ApplicationController
    def create
      @person_education = current_user.adresses.build(params[:person_education])
      @person_education.save!
      redirect_to current_user
    end

    def update
      @person_education = current_user.educations.find(params[:id])
      @person_education.update!(params[:person_education])
      redirect_to current_user
    end

    def destroy
      @person_education = current_user.educations.find(params[:id])
      @person_education.destroy
      redirect_to current_user
    end
  end
end
