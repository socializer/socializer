module Socializer
  class PersonPhonesController < ApplicationController
    def create
      @person_phone = current_user.adresses.build(params[:person_phone])
      @person_phone.save!
      redirect_to current_user
    end

    def update
      @person_phone = current_user.phones.find(params[:id])
      @person_phone.update!(params[:person_phone])
      redirect_to current_user
    end

    def destroy
      @person_phone = current_user.phones.find(params[:id])
      @person_phone.destroy
      redirect_to current_user
    end
  end
end
