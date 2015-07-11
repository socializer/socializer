require "rails_helper"

module Socializer
  RSpec.describe NotificationsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/notifications")
        .to route_to("socializer/notifications#index")
      end

      it "does not route to #new" do
        expect(get: "/notifications/new")
        .to_not route_to("socializer/notifications#new")
      end

      it "routes to #show" do
        expect(get: "/notifications/1")
        .to route_to("socializer/notifications#show", id: "1")
      end

      it "does not route to #edit" do
        expect(get: "/notifications/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/notifications").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/notifications/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/notifications/1").to_not be_routable
      end
    end
  end
end
