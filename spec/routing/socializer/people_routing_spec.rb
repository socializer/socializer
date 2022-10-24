# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe PeopleController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/people").to route_to("socializer/people#index")
      end

      it "does not route to #new" do
        # expect(get: "/people/new").not_to be_routable
        expect(get: "/people/new").not_to route_to("socializer/people#new")
      end

      it "routes to #show" do
        expect(get: "/people/1")
          .to route_to("socializer/people#show", id: "1")
      end

      it "routes to #edit" do
        expect(get: "/people/1/edit")
          .to route_to("socializer/people#edit", id: "1")
      end

      it "does not route to #create" do
        expect(post: "/people").not_to be_routable
      end

      it "routes to #update" do
        expect(patch: "/people/1")
          .to route_to("socializer/people#update", id: "1")
      end

      it "does not route to #destroy" do
        expect(delete: "/people/1").not_to be_routable
      end
    end
  end
end
