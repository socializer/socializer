# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for handling people-related actions
  #
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
        contribution = contributions.build(person_contribution_params)

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
        contribution.update!(person_contribution_params)

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

      # Returns the memoized collection of contributions for the currently authenticated user.
      #
      # Lazily loads `current_user.contributions` into `@contributions` and returns it.
      # Subsequent calls will return the memoized value to avoid additional database queries.
      #
      # @return [ActiveRecord::Relation<Socializer::Contribution>] the contributions for the current user
      #
      # @example
      #   # given current_user has contributions
      #   contributions
      #   # => #<ActiveRecord::Relation [#<Socializer::Contribution id: 2, ...>]>
      def contributions
        return @contributions if defined?(@contributions)

        @contributions = current_user.contributions
      end

      # Finds and memoizes a contribution belonging to the current_user using params[:id].
      # Returns nil if no matching contribution is found.
      #
      # @return [Socializer::Contribution, nil] the found contribution or nil
      #
      # @example
      #   # given params[:id] = "2" and current_user has a contribution with id 2
      #   find_contribution
      #   # => #<Socializer::Contribution id: 2, ...>
      def find_contribution
        return @find_contribution if defined?(@find_contribution)

        @find_contribution = contributions.find_by(id: params[:id])
      end

      # Returns the strong parameters for a person's contribution.
      #
      # Uses the incoming `params` to extract the `:person_contribution` attributes
      # expected by the controller actions.
      #
      # @return [ActionController::Parameters] permitted parameters hash
      #
      # @example
      #   # Given params: { person_contribution: { display_name: "Proj", label: "Open", url: "https://", current: true } }
      #   person_contribution_params
      #   # => { "display_name" => "Proj", "label" => "Open", "url" => "https://", "current" => true }
      def person_contribution_params
        params.expect(person_contribution: %i[display_name label url current])
      end
    end
  end
end
