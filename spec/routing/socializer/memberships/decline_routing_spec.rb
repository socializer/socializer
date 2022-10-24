# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Memberships::DeclineController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "does not route to #index" do
        expect(get: "/memberships/1/decline").not_to be_routable
      end

      it "does not route to #new" do
        expect(get: "/memberships/1/decline/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/memberships/1/decline/1/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/memberships/1/decline/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/memberships/1/decline").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/memberships/1/decline/1").not_to be_routable }
        specify { expect(put: "/memberships/1/decline/1").not_to be_routable }
      end

      it "routes to #destroy" do
        expect(delete: "/memberships/1/decline")
          .to route_to("socializer/memberships/decline#destroy", id: "1")
      end
    end
  end
end
