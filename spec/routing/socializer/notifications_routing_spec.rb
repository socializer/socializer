# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe NotificationsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/notifications")
          .to route_to("socializer/notifications#index")
      end

      it "does not route to #new" do
        expect(get: "/notifications/new")
          .not_to route_to("socializer/notifications#new")
      end

      it "routes to #show" do
        expect(get: "/notifications/1")
          .to route_to("socializer/notifications#show", id: "1")
      end

      it "does not route to #edit" do
        expect(get: "/notifications/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/notifications").not_to be_routable
      end

      it "does not route to #update" do
        expect(patch: "/notifications/1").not_to be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/notifications/1").not_to be_routable
      end
    end
  end
end
