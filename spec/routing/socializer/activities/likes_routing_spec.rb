# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activities::LikesController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/activities/1/likes")
          .to route_to("socializer/activities/likes#index", id: "1")
      end

      it "does not route to #new" do
        expect(get: "/activities/1/likes/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/activities/1/likes/show/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/activities/1/likes/1/edit").not_to be_routable
      end

      it "routes to #create" do
        expect(post: "/activities/1/like")
          .to route_to("socializer/activities/likes#create", id: "1")
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/activities/1/likes/1").not_to be_routable }
        specify { expect(put: "/activities/1/likes/1").not_to be_routable }
      end

      it "routes to #destroy" do
        expect(delete: "/activities/1/unlike")
          .to route_to("socializer/activities/likes#destroy", id: "1")
      end
    end
  end
end
