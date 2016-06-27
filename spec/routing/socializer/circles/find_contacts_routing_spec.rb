# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circles::SuggestionsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/circles/suggestions")
          .to route_to("socializer/circles/suggestions#index")
      end

      it "does not route to #new" do
        expect(get: "/circles/suggestions/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/circles/suggestions/show/1").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/circles/suggestions/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/circles/suggestions").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/circles/suggestions/1").to_not be_routable
        expect(put: "/circles/suggestions/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/circles/suggestions/1").to_not be_routable
      end
    end
  end
end
