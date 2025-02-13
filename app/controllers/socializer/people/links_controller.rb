# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
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

      def links
        return @links if defined?(@links)

        @links = current_user.links
      end

      def find_link
        return @find_link if defined?(@find_link)

        @find_link = links.find_by(id: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def person_link_params
        params.expect(person_link: %i[display_name url])
      end
    end
  end
end
