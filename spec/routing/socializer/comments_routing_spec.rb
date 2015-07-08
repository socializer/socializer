require "rails_helper"

module Socializer
  RSpec.describe CommentsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/comments").to_not be_routable
      end

      it "routes to #new" do
        expect(get: "/comments/new").to route_to("socializer/comments#new")
      end

      it "does not route to #show" do
        expect(get: "/comments/1").to_not be_routable
      end

      it "routes to #edit" do
        expect(get: "/comments/1/edit").to route_to("socializer/comments#edit", id: "1")
      end

      it "routes to #create" do
        expect(post: "/comments").to route_to("socializer/comments#create")
      end

      it "routes to #update" do
        expect(patch: "/comments/1").to route_to("socializer/comments#update", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/comments/1").to route_to("socializer/comments#destroy", id: "1")
      end
    end
  end
end
