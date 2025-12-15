# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Pages controller
  class PagesController < ApplicationController
    # GET /pages
    def index
      redirect_to activities_path if signed_in?
    end
  end
end
