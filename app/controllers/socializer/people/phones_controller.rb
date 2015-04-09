#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class PhonesController < ApplicationController
      before_action :authenticate_user
      before_action :set_person_phone, only: [:update, :destroy]

      # POST /people/1/phones
      def create
        @person_phone = current_user.phones.build(params[:person_phone])
        @person_phone.save!
        redirect_to current_user
      end

      # PATCH/PUT /people/1/phones/1
      def update
        @person_phone.update!(params[:person_phone])
        redirect_to current_user
      end

      # DELETE /people/1/phones/1
      def destroy
        @person_phone.destroy
        redirect_to current_user
      end

      private

      def set_person_phone
        @person_phone = current_user.phones.find_by(id: params[:id])
      end
    end
  end
end
