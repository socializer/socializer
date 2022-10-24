# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe People::ContributionsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "does not route to #index" do
        expect(get: "/people/1/contributions").not_to be_routable
      end

      it "routes to #new" do
        expect(get: "/people/1/contributions/new")
          .to route_to("socializer/people/contributions#new", person_id: "1")
      end

      it "does not route to #show" do
        expect(get: "/people/1/contributions/1/show").not_to be_routable
      end

      it "routes to #edit" do
        expect(get: "/people/1/contributions/1/edit")
          .to route_to("socializer/people/contributions#edit",
                       person_id: "1", id: "1")
      end

      it "routes to #create" do
        expect(post: "/people/1/contributions")
          .to route_to("socializer/people/contributions#create", person_id: "1")
      end

      it "routes to #update using patch" do
        expect(patch: "/people/1/contributions/1")
          .to route_to("socializer/people/contributions#update",
                       person_id: "1",
                       id: "1")
      end

      it "routes to #update using put" do
        expect(put: "/people/1/contributions/1")
          .to route_to("socializer/people/contributions#update",
                       person_id: "1",
                       id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/people/1/contributions/1")
          .to route_to("socializer/people/contributions#destroy",
                       person_id: "1",
                       id: "1")
      end
    end
  end
end
