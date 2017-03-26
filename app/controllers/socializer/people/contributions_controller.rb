# frozen_string_literal: true

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
        respond_to do |format|
          format.html do
            render :new, locals: { contribution: contributions.new }
          end
        end
      end

      # GET /people/1/addresses/1/edit
      def edit
        respond_to do |format|
          format.html do
            render :edit, locals: { contribution: find_contribution }
          end
        end
      end

      # POST /people/1/contributions
      def create
        contribution = contributions.build(params[:person_contribution])

        if contribution.save
          flash[:notice] = t("socializer.model.create", model: "Contribution")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/contributions/1
      def update
        contribution = find_contribution
        contribution.update!(params[:person_contribution])

        flash[:notice] = t("socializer.model.update", model: "Contribution")
        redirect_to current_user
      end

      # DELETE /people/1/contributions/1
      def destroy
        contribution = find_contribution
        contribution.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Contribution")
        redirect_to current_user
      end

      private

      def contributions
        @contributions ||= current_user.contributions
      end

      def find_contribution
        @find_contribution ||= contributions.find_by(id: params[:id])
      end
    end
  end
end
