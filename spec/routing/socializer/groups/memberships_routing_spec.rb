# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Groups::MembershipsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/groups/memberships")
          .to route_to("socializer/groups/memberships#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/memberships/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/memberships/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/memberships/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/memberships").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/groups/memberships/1").not_to be_routable }
        specify { expect(put: "/groups/memberships/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/memberships/1").not_to be_routable
      end
    end
  end
end
