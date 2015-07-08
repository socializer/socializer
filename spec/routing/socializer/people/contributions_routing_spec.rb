require "rails_helper"

module Socializer
  RSpec.describe People::ContributionsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/people/1/contributions").to_not be_routable
      end

      it "does not route to #new" do
        expect(get: "/people/1/contributions/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/people/1/contributions/1/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/people/1/contributions/1/edit").to_not be_routable
      end

      it "routes to #create" do
        expect(post: "/people/1/contributions").to route_to("socializer/people/contributions#create", person_id: "1")
      end

      it "routes to #update" do
        expect(patch: "/people/1/contributions/1").to route_to("socializer/people/contributions#update", person_id: "1", id: "1")
        expect(put: "/people/1/contributions/1").to route_to("socializer/people/contributions#update", person_id: "1", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/people/1/contributions/1").to route_to("socializer/people/contributions#destroy", person_id: "1", id: "1")
      end
    end
  end
end
