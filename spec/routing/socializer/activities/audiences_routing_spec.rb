require "rails_helper"

module Socializer
  RSpec.describe Activities::AudiencesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/activities/1/audience")
        .to route_to("socializer/activities/audiences#index", id: "1")
      end

      it "does not route to #new" do
        expect(get: "/activities/1/activities/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/activities/1/activities/1/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/activities/1/activities/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/activities/1/activities").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/activities/1/activities/1").to_not be_routable
        expect(put: "/activities/1/activities/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/activities/1/activities/1").to_not be_routable
      end
    end
  end
end
