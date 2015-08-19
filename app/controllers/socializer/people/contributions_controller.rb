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

      # GET /people/1/contributions/new
      def new
        @person_contribution = current_user.contributions.new
      end

      # GET /people/1/addresses/1/edit
      def edit
        @person_contribution = find_person_contribution
      end

      # POST /people/1/contributions
      def create
        @person_contribution = create_person_contribution

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

      def contributions
        @contributions ||= current_user.contributions
      end

      def find_person_contribution
        current_user.contributions.find_by(id: params[:id])
      end

      def create_person_contribution
        contributions.create!(params[:person_contribution])
      end
    end
  end
end
