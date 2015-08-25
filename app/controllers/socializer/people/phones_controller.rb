#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Phones controller
    #
    class PhonesController < ApplicationController
      before_action :authenticate_user

      # POST /people/1/phones
      def create
        @phone = phones.create!(params[:person_phone])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/phones/1
      def update
        @phone = find_phone
        @phone.update!(params[:person_phone])

        redirect_to current_user
      end

      # DELETE /people/1/phones/1
      def destroy
        @phone = find_phone
        @phone.destroy

        redirect_to current_user
      end

      private

      def phones
        @phones ||= current_user.phones
      end

      def find_phone
        current_user.phones.find_by(id: params[:id])
      end
    end
  end
end
