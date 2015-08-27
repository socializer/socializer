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
        @contribution = contributions.new
      end

      # GET /people/1/addresses/1/edit
      def edit
        @contribution = find_contribution
      end

      # POST /people/1/contributions
      def create
        @contribution = create_contribution

        redirect_to current_user
      end

      # PATCH/PUT /people/1/contributions/1
      def update
        @contribution = find_contribution
        @contribution.update!(params[:person_contribution])

        redirect_to current_user
      end

      # DELETE /people/1/contributions/1
      def destroy
        @contribution = find_contribution
        @contribution.destroy

        redirect_to current_user
      end

      private

      def contributions
        @contributions ||= current_user.contributions
      end

      def find_contribution
        contributions.find_by(id: params[:id])
      end

      def create_contribution
        contributions.create!(params[:person_contribution])
      end
    end
  end
end
