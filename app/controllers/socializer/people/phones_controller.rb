# frozen_string_literal: true
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

      # GET /people/1/phones/new
      def new
        @phone = phones.new
      end

      # GET /people/1/phones/1/edit
      def edit
        @phone = find_phone
      end

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
        phones.find_by(id: params[:id])
      end
    end
  end
end
