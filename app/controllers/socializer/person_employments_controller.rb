module Socializer
  class PersonEmploymentsController < ApplicationController
    def create
      @person_employment = current_user.adresses.build(params[:person_employment])
      @person_employment.save!
      redirect_to current_user
    end

    def update
      @person_employment = current_user.employments.find(params[:id])
      @person_employment.update!(params[:person_employment])
      redirect_to current_user
    end

    def destroy
      @person_employment = current_user.employments.find(params[:id])
      @person_employment.destroy
      redirect_to current_user
    end
  end
end
