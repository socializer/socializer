module Socializer
  class ApplicationController < ActionController::Base
    
    helper_method :current_user
    helper_method :signed_in?
    
    private
  
    def current_user
      @current_user ||= Person.find(cookies[:user_id]) if !cookies[:user_id].nil?
    end    

    def signed_in?
      return true if current_user
      return false
    end
    
  end
end
