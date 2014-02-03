module Socializer
  class PersonLinksController < ApplicationController
    def create
      @person_link = current_user.adresses.build(params[:person_link])
      @person_link.save!
      redirect_to current_user
    end

    def update
      @person_link = current_user.links.find(params[:id])
      @person_link.update!(params[:person_link])
      redirect_to current_user
    end

    def destroy
      @person_link = current_user.links.find(params[:id])
      @person_link.destroy
      redirect_to current_user
    end
  end
end
