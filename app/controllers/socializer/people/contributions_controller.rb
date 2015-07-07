#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Contributions controller
    #
    class ContributionsController < ApplicationController
      before_action :authenticate_user

      # POST /people/1/contributions
      def create
        @person_contribution = current_user.contributions.build(params[:person_contribution])
        @person_contribution.save!
        redirect_to current_user
      end

      # PATCH/PUT /people/1/contributions/1
      def update
        @person_contribution = find_person_contribution
        @person_contribution.update!(params[:person_contribution])
        redirect_to current_user
      end

      # DELETE /people/1/contributions/1
      def destroy
        @person_contribution = find_person_contribution
        @person_contribution.destroy
        redirect_to current_user
      end

      private

      def find_person_contribution
        current_user.contributions.find_by(id: params[:id])
      end
    end
  end
end
