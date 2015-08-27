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
        @address = addresses.new
      end

      # GET /people/1/addresses/1/edit
      def edit
        @address = find_address
      end

      # POST /people/1/addresses
      def create
        @address = addresses.create!(params[:person_address])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/addresses/1
      def update
        @address = find_address
        @address.update!(params[:person_address])

        redirect_to current_user
      end

      # DELETE /people/1/addresses/1
      def destroy
        @address = find_address
        @address.destroy

        redirect_to current_user
      end

      private

      def addresses
        @addresses ||= current_user.addresses
      end

      def find_address
        addresses.find_by(id: params[:id])
      end
    end
  end
end
