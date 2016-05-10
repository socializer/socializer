require "rails_helper"

module Socializer
  RSpec.describe People::LinksController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/people/1/links").to_not be_routable
      end

      it "routes to #new" do
        expect(get: "/people/1/links/new")
          .to route_to("socializer/people/links#new", person_id: "1")
      end

      it "does not route to #show" do
        expect(get: "/people/1/links/1/show").to_not be_routable
      end

      it "routes to #edit" do
        expect(get: "/people/1/links/1/edit")
          .to route_to("socializer/people/links#edit",
                       person_id: "1", id: "1")
      end

      it "routes to #create" do
        expect(post: "/people/1/links")
          .to route_to("socializer/people/links#create", person_id: "1")
      end

      it "routes to #update" do
        expect(patch: "/people/1/links/1")
          .to route_to("socializer/people/links#update",
                       person_id: "1", id: "1")

        expect(put: "/people/1/links/1")
          .to route_to("socializer/people/links#update",
                       person_id: "1", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/people/1/links/1")
          .to route_to("socializer/people/links#destroy",
                       person_id: "1", id: "1")
      end
    end
  end
end
