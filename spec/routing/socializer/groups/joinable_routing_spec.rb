require "rails_helper"

module Socializer
  RSpec.describe Groups::JoinableController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/groups/joinable")
          .to route_to("socializer/groups/joinable#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/joinable/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/joinable/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/joinable/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/joinable").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/groups/joinable/1").to_not be_routable
        expect(put: "/groups/joinable/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/joinable/1").to_not be_routable
      end
    end
  end
end
