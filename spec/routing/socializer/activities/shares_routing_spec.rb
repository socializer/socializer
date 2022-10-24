# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activities::SharesController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "does not route to #index" do
        expect(get: "/activities/1/shares").not_to be_routable
      end

      it "routes to #new" do
        expect(get: "/activities/1/share")
          .to route_to("socializer/activities/shares#new", id: "1")
      end

      it "does not route to #show" do
        expect(get: "/activities/1/shares/show/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/activities/1/shares/1/edit").not_to be_routable
      end

      it "routes to #create" do
        expect(post: "/activities/1/share")
          .to route_to("socializer/activities/shares#create", id: "1")
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/activities/1/shares/1").not_to be_routable }
        specify { expect(put: "/activities/1/shares/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/activities/1/shares/1").not_to be_routable
      end
    end
  end
end
