# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe AuthenticationsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/authentications")
          .to route_to("socializer/authentications#index")
      end

      it "does not route to #new" do
        expect(get: "/authentications/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/authentications/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/authentications/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/authentications").not_to be_routable
      end

      it "does not route to #update" do
        expect(patch: "/authentications/1").not_to be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/authentications/1")
          .to route_to("socializer/authentications#destroy", id: "1")
      end
    end
  end
end
