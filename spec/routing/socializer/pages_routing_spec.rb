# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe PagesController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/").to route_to("socializer/pages#index")
      end

      it "does not route to #new" do
        expect(get: "/pages/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/pages/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/pages/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/pages").not_to be_routable
      end

      it "does not route to #update" do
        expect(patch: "/pages/1").not_to be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/pages/1").not_to be_routable
      end
    end
  end
end
