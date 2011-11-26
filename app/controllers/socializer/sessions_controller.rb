module Socializer
  class SessionsController < ApplicationController

    def create
      auth = request.env["omniauth.auth"]
      user_auth = Authentication.where(:provider => auth['provider'], :uid => auth['uid']).first
      if user_auth.nil?
        if signed_in?
          current_user.authentications.build(:provider => auth['provider'], :uid => auth['uid']).save!
          redirect_to authentications_path
        else
          user = Person.create_with_omniauth(auth)
          user.embedded_object.circles.build(:name => "Friends",       :description => "Your real friends, the ones you feel comfortable sharing private details with.").save!
          user.embedded_object.circles.build(:name => "Family",        :description => "Your close and extended family, with as many or as few in-laws as you want.").save!
          user.embedded_object.circles.build(:name => "Acquaintances", :description => "A good place to stick people you've met but aren't particularly close to.").save!
          user.embedded_object.circles.build(:name => "Following",     :description => "People you don't know personally, but whose posts you find interesting.").save!
        end
      else
        user = user_auth.person unless user_auth.nil?
      end
      if user
        cookies[:user_id] = { :domain => :all, :value => "#{user.id}" }
        redirect_to root_url
      end
    end
    
    def destroy
      cookies.delete :user_id, :domain => :all
      redirect_to root_url
    end
    
    def failure
      redirect_to root_url
    end

  end
end
