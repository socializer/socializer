module Socializer
  class AuthenticationsController < ApplicationController
    def index
      @authentications = current_user.services
    end

    def destroy
      @authentication = current_user.authentications.find(params[:id])
      @authentication.destroy
      redirect_to authentications_path
    end
  end
end
