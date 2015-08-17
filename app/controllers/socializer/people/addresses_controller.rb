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

      # GET /people/1/addresses/new
      def new
        @person_address = current_user.addresses.new
      end

      # GET /people/1/addresses/1/edit
      def edit
        @person_address = find_person_address
      end

      # POST /people/1/addresses
      def create
        @person_address = addresses.create!(params[:person_address])

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

      def addresses
        @addresses ||= current_user.addresses
      end

      def find_person_address
        current_user.addresses.find_by(id: params[:id])
      end
    end
  end
end
