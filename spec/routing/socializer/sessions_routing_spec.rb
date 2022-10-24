# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe MembershipsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "does not route to #index" do
        expect(get: "/sessions").not_to be_routable
      end

      it "routes to #new" do
        expect(get: "/signin").to route_to("socializer/sessions#new")
      end

      it "does not route to #show" do
        expect(get: "/sessions/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/sessions/1/edit").not_to be_routable
      end

      it "routes to #create" do
        expect(post: "/auth/identity/callback")
          .to route_to("socializer/sessions#create", provider: "identity")
      end

      it "does not route to #update" do
        expect(patch: "/sessions/1").not_to be_routable
      end

      it "routes to #destroy" do
        expect(delete: "/signout")
          .to route_to("socializer/sessions#destroy")
      end

      it "routes to #failure" do
        expect(post: "/auth/failure")
          .to route_to("socializer/sessions#failure")
      end
    end
  end
end
