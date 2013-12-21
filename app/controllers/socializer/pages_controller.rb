module Socializer
  class PagesController < ApplicationController
    def index
      if signed_in?
        redirect_to stream_path
      end
    end
  end
end
