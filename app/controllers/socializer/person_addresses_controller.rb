module Socializer
  class PersonAddressesController < ApplicationController
    before_filter :set_person_address, only: [:update, :destroy]

    def create
      @person_address = current_user.adresses.build(params[:person_address])
      @person_address.save!
      redirect_to current_user
    end

    def update
      @person_address.update!(params[:person_address])
      redirect_to current_user
    end

    def destroy
      @person_address.destroy
      redirect_to current_user
    end

    private

    def set_person_address
      @person_address = current_user.addresses.find(params[:id])
    end
  end
end
