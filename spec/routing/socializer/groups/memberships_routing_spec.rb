require "rails_helper"

module Socializer
  RSpec.describe Groups::MembershipsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/groups/memberships")
          .to route_to("socializer/groups/memberships#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/memberships/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/memberships/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/memberships/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/memberships").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/groups/memberships/1").to_not be_routable
        expect(put: "/groups/memberships/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/memberships/1").to_not be_routable
      end
    end
  end
end
