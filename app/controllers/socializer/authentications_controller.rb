# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Authentications controller
  class AuthenticationsController < ApplicationController
    before_action :authenticate_user

    # GET /authentications
    def index
      respond_to do |format|
        format.html do
          render :index, locals: { authentications: current_user&.services }
        end
      end
    end

    # DELETE /authentications/1
    def destroy
      authentication = current_user.authentications.find_by(id: params[:id])
      authentication.destroy

      redirect_to authentications_path
    end
  end
end
