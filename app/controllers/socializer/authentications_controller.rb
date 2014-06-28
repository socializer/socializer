#
# Namespace for the Socializer engine
#
module Socializer
  class AuthenticationsController < ApplicationController
    # GET /authentications
    def index
      @authentications = current_user.services
    end

    # DELETE /authentications/1
    def destroy
      @authentication = current_user.authentications.find_by(id: params[:id])
      @authentication.destroy
      redirect_to authentications_path
    end
  end
end
