#
# Namespace for the Socializer engine
#
module Socializer
  class PagesController < ApplicationController
    def index
      redirect_to activities_path if signed_in?
    end
  end
end
