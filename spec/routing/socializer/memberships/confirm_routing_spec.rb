require "rails_helper"

module Socializer
  RSpec.describe Memberships::ConfirmController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/memberships/1/confirm").to_not be_routable
      end

      it "does not route to #new" do
        expect(get: "/memberships/1/confirm/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/memberships/1/confirm/1/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/memberships/1/confirm/1/edit").to_not be_routable
      end

      it "routes to #create" do
        expect(post: "/memberships/1/confirm")
        .to route_to("socializer/memberships/confirm#create", id: "1")
      end

      it "does not route to #update" do
        expect(patch: "/memberships/1/confirm/1").to_not be_routable
        expect(put: "/memberships/1/confirm/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/memberships/1/confirm").to_not be_routable
      end
    end
  end
end
