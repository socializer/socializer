require "rails_helper"

module Socializer
  RSpec.describe TiesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/ties").to_not be_routable
      end

      it "does not route to #new" do
        expect(get: "/ties/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/ties/1").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/ties/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/ties").to route_to("socializer/ties#create")
      end

      it "does not route to #update" do
        expect(patch: "/ties/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/ties/1")
        .to route_to("socializer/ties#destroy", id: "1")
      end
    end
  end
end
