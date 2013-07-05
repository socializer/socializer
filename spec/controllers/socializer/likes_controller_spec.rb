require 'spec_helper'

module Socializer
  describe LikesController do

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    describe "GET 'create'" do
      it "returns http success" do
        get 'create'
        response.should be_success
      end
    end

    describe "GET 'destroy'" do
      it "returns http success" do
        get 'destroy'
        response.should be_success
      end
    end

  end
end
