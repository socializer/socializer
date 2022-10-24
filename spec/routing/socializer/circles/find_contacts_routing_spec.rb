# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circles::SuggestionsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/circles/suggestions")
          .to route_to("socializer/circles/suggestions#index")
      end

      it "does not route to #new" do
        expect(get: "/circles/suggestions/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/circles/suggestions/show/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/circles/suggestions/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/circles/suggestions").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/circles/suggestions/1").not_to be_routable }
        specify { expect(put: "/circles/suggestions/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/circles/suggestions/1").not_to be_routable
      end
    end
  end
end
