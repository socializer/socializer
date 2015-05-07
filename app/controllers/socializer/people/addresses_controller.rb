#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class AddressesController < ApplicationController
      before_action :authenticate_user
      before_action :set_person_address, only: [:update, :destroy]

      # POST /people/1/addresses
      def create
        @person_address = current_user.addresses.build(params[:person_address])
        @person_address.save!
        redirect_to current_user
      end

      # PATCH/PUT /people/1/addresses/1
      def update
        @person_address.update!(params[:person_address])
        redirect_to current_user
      end

      # DELETE /people/1/addresses/1
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
end
