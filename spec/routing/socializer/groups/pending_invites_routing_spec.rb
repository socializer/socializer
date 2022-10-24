# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Groups::PendingInvitesController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/groups/pending_invites")
          .to route_to("socializer/groups/pending_invites#index")
      end

      it "does not route to #new" do
        expect(get: "/groups/pending_invites/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/groups/pending_invites/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/groups/pending_invites/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/groups/pending_invites").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify do
          expect(patch: "/groups/pending_invites/1").not_to be_routable
        end

        specify { expect(put: "/groups/pending_invites/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/groups/pending_invites/1").not_to be_routable
      end
    end
  end
end
