# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Memberships::ConfirmController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "does not route to #index" do
        expect(get: "/memberships/1/confirm").not_to be_routable
      end

      it "does not route to #new" do
        expect(get: "/memberships/1/confirm/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/memberships/1/confirm/1/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/memberships/1/confirm/1/edit").not_to be_routable
      end

      it "routes to #create" do
        expect(post: "/memberships/1/confirm")
          .to route_to("socializer/memberships/confirm#create", id: "1")
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/memberships/1/confirm/1").not_to be_routable }
        specify { expect(put: "/memberships/1/confirm/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/memberships/1/confirm").not_to be_routable
      end
    end
  end
end
