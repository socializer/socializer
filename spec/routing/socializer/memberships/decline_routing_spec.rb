require "rails_helper"

module Socializer
  RSpec.describe Memberships::DeclineController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/memberships/1/decline").to_not be_routable
      end

      it "does not route to #new" do
        expect(get: "/memberships/1/decline/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/memberships/1/decline/1/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/memberships/1/decline/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/memberships/1/decline").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/memberships/1/decline/1").to_not be_routable
        expect(put: "/memberships/1/decline/1").to_not be_routable
      end

      it "routes to #destroy" do
        expect(delete: "/memberships/1/decline").to route_to("socializer/memberships/decline#destroy", id: "1")
      end
    end
  end
end
