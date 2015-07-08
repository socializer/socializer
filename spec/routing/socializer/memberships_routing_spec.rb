require "rails_helper"

module Socializer
  RSpec.describe MembershipsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/memberships").to_not be_routable
      end

      it "does not route to #new" do
        expect(get: "/memberships/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/memberships/1").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/memberships/1/edit").to_not be_routable
      end

      it "routes to #create" do
        expect(post: "/memberships").to route_to("socializer/memberships#create")
      end

      it "does not route to #update" do
        expect(patch: "/memberships/1").to_not be_routable
      end

      it "routes to #destroy" do
        expect(delete: "/memberships/1").to route_to("socializer/memberships#destroy", id: "1")
      end
    end
  end
end
