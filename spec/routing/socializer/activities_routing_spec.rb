require "rails_helper"

module Socializer
  RSpec.describe ActivitiesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/activities")
          .to route_to("socializer/activities#index")
      end

      it "does not route to #new" do
        expect(get: "/activities/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/activities/1").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/activities/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/activities").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/activities/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/activities/1")
          .to route_to("socializer/activities#destroy", id: "1")
      end
    end
  end
end
