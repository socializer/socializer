require "rails_helper"

module Socializer
  RSpec.describe People::ProfilesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/people/1/profiles").to_not be_routable
      end

      it "does not route to #new" do
        expect(get: "/people/1/profiles/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/people/1/profiles/1/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/people/1/profiles/1/edit").to_not be_routable
      end

      it "routes to #create" do
        expect(post: "/people/1/profiles")
        .to route_to("socializer/people/profiles#create", person_id: "1")
      end

      it "routes to #update" do
        expect(patch: "/people/1/profiles/1")
        .to route_to(
          "socializer/people/profiles#update",
          person_id: "1",
          id: "1")

        expect(put: "/people/1/profiles/1")
        .to route_to(
          "socializer/people/profiles#update",
          person_id: "1",
          id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/people/1/profiles/1")
        .to route_to(
          "socializer/people/profiles#destroy",
          person_id: "1",
          id: "1")
      end
    end
  end
end
