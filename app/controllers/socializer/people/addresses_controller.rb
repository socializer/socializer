#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Address controller
    #
    class AddressesController < ApplicationController
      before_action :authenticate_user

      # POST /people/1/addresses
      def create
        @person_address = current_user.addresses.create!(params[:person_address])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/addresses/1
      def update
        @person_address = find_person_address
        @person_address.update!(params[:person_address])

        redirect_to current_user
      end

      # DELETE /people/1/addresses/1
      def destroy
        @person_address = find_person_address
        @person_address.destroy

        redirect_to current_user
      end

      private

      def find_person_address
        current_user.addresses.find_by(id: params[:id])
      end
    end
  end
end
