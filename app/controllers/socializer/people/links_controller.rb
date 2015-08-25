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

      # POST /people/1/links
      def create
        @link = links.create!(params[:person_link])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/links/1
      def update
        @link = find_link
        @link.update!(params[:person_link])

        redirect_to current_user
      end

      # DELETE /people/1/links/1
      def destroy
        @link = find_link
        @link.destroy

        redirect_to current_user
      end

      private

      def links
        @links ||= current_user.links
      end

      def find_link
        current_user.links.find_by(id: params[:id])
      end
    end
  end
end
