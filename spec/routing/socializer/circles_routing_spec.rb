# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe CirclesController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/circles").to route_to("socializer/circles#index")
      end

      it "routes to #new" do
        expect(get: "/circles/new").to route_to("socializer/circles#new")
      end

      it "routes to #show" do
        expect(get: "/circles/1")
          .to route_to("socializer/circles#show", id: "1")
      end

      it "routes to #edit" do
        expect(get: "/circles/1/edit")
          .to route_to("socializer/circles#edit", id: "1")
      end

      it "routes to #create" do
        expect(post: "/circles").to route_to("socializer/circles#create")
      end

      it "routes to #update" do
        expect(patch: "/circles/1")
          .to route_to("socializer/circles#update", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/circles/1")
          .to route_to("socializer/circles#destroy", id: "1")
      end
    end
  end
end
