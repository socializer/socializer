# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Groups::PublicController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/groups/public")
          .to route_to("socializer/groups/public#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/public/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/public/show").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/public/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/public").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/groups/public/1").to_not be_routable
        expect(put: "/groups/public/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/public/1").to_not be_routable
      end
    end
  end
end
