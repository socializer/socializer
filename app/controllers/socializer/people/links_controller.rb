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
    # Links controller
    #
    class LinksController < ApplicationController
      before_action :authenticate_user

      # GET /people/1/links/new
      def new
        respond_to do |format|
          format.html { render :new, locals: { link: links.new } }
        end
      end

      # GET /people/1/links/1/edit
      def edit
        respond_to do |format|
          format.html { render :edit, locals: { link: find_link } }
        end
      end

      # POST /people/1/links
      def create
        link = links.build(person_link_params)

        if link.save
          flash[:notice] = t("socializer.model.create", model: "Link")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/links/1
      def update
        link = find_link

        if link.update(person_link_params)
          flash[:notice] = t("socializer.model.update", model: "Link")
          redirect_to current_user
        else
          render :edit
        end
      end

      # DELETE /people/1/links/1
      def destroy
        link = find_link
        link.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Link")
        redirect_to current_user
      end

      private

      # Returns the collection of Link records belonging to the current user.
      #
      # This method memoizes the association in `@links` so subsequent calls
      # within the same request reuse the loaded collection and avoid extra
      # database queries.
      #
      # @return [ActiveRecord::Relation<Socializer::Link>] the current user's links
      #
      # @example
      #   # in controller actions
      #   link_collection = links
      #   link_collection.first # => first Link for current_user
      def links
        return @links if defined?(@links)

        @links = current_user.links
      end

      # Finds and memoizes a Link record owned by the current user using
      # the `params[:id]` value.
      #
      # This prevents multiple database lookups within the same request by
      # returning a cached instance on subsequent calls.
      #
      # @return [Socializer::Link, nil] the Link if found, otherwise `nil`
      #
      # @example
      #   # in controller actions
      #   link = find_link
      #   if link
      #     link.update(title: "New")
      #   else
      #     # handle missing link
      #   end
      def find_link
        return @find_link if defined?(@find_link)

        @find_link = links.find_by(id: params[:id])
      end

      # Strong-parameters helper for person link attributes.
      #
      # @return [ActionController::Parameters] permitted parameters for a Link
      #
      # @example
      #   # in controller create action
      #   link = links.build(person_link_params)
      def person_link_params
        params.expect(person_link: %i[display_name url])
      end
    end
  end
end
