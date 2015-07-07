#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Messages controller
    #
    class MessagesController < ApplicationController
      before_action :authenticate_user

      # GET people/1/messages/new
      def new
        @person = Person.find_by(id: params[:id]).decorate
        @current_id = @person.guid
        @note = Note.new
      end
    end
  end
end
