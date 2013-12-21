module Socializer
  class PagesController < ApplicationController
    def index
      redirect_to stream_path if signed_in?
    end
  end
end
