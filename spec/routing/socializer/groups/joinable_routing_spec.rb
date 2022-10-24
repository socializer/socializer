# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Groups::JoinableController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/groups/joinable")
          .to route_to("socializer/groups/joinable#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/joinable/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/joinable/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/joinable/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/joinable").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/groups/joinable/1").not_to be_routable }
        specify { expect(put: "/groups/joinable/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/joinable/1").not_to be_routable
      end
    end
  end
end
