# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe GroupsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/groups").to route_to("socializer/groups#index")
      end

      it "routes to #new" do
        expect(get: "/groups/new").to route_to("socializer/groups#new")
      end

      it "routes to #show" do
        expect(get: "/groups/1")
          .to route_to("socializer/groups#show", id: "1")
      end

      it "routes to #edit" do
        expect(get: "/groups/1/edit")
          .to route_to("socializer/groups#edit", id: "1")
      end

      it "routes to #create" do
        expect(post: "/groups").to route_to("socializer/groups#create")
      end

      it "routes to #update" do
        expect(patch: "/groups/1")
          .to route_to("socializer/groups#update", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/groups/1")
          .to route_to("socializer/groups#destroy", id: "1")
      end
    end
  end
end
