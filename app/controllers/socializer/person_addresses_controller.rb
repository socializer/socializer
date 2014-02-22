module Socializer
  class PersonAddressesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_person_address, only: [:update, :destroy]

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
      @person_address = current_user.addresses.find_by(id: params[:id])
    end
  end
end
