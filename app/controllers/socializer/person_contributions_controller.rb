module Socializer
  class PersonContributionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_person_contribution, only: [:update, :destroy]

    def create
      @person_contribution = current_user.contributions.build(params[:person_contribution])
      @person_contribution.save!
      redirect_to current_user
    end

    def update
      @person_contribution.update!(params[:person_contribution])
      redirect_to current_user
    end

    def destroy
      @person_contribution.destroy
      redirect_to current_user
    end

    private

    def set_person_contribution
      @person_contribution = current_user.contributions.find(params[:id])
    end
  end
end
