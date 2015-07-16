require "rails_helper"

module Socializer
  RSpec.describe Groups::RestrictedController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/groups/restricted")
          .to route_to("socializer/groups/restricted#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/restricted/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/restricted/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/restricted/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/restricted").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/groups/restricted/1").to_not be_routable
        expect(put: "/groups/restricted/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/restricted/1").to_not be_routable
      end
    end
  end
end
