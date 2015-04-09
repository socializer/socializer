#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class ContributionsController < ApplicationController
      before_action :authenticate_user
      before_action :set_person_contribution, only: [:update, :destroy]

      # POST /people/1/contributions
      def create
        @person_contribution = current_user.contributions.build(params[:person_contribution])
        @person_contribution.save!
        redirect_to current_user
      end

      # PATCH/PUT /people/1/contributions/1
      def update
        @person_contribution.update!(params[:person_contribution])
        redirect_to current_user
      end

      # DELETE /people/1/contributions/1
      def destroy
        @person_contribution.destroy
        redirect_to current_user
      end

      private

      def set_person_contribution
        @person_contribution = current_user.contributions.find_by(id: params[:id])
      end
    end
  end
end
