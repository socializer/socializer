module Socializer
  class PersonAddressesController < ApplicationController
    def create
      @person_address = current_user.adresses.build(params[:person_address])
      @person_address.save!
      redirect_to current_user
    end

    def update
      @person_address = current_user.addresses.find(params[:id])
      @person_address.update!(params[:person_address])
      redirect_to current_user
    end

    def destroy
      @person_address = current_user.addresses.find(params[:id])
      @person_address.destroy
      redirect_to current_user
    end
  end
end
