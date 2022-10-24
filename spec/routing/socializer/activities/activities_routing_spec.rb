# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activities::ActivitiesController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/activities/1/activities")
          .to route_to("socializer/activities/activities#index",
                       activity_id: "1")
      end

      it "does not route to #new" do
        expect(get: "/activities/1/activities/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/activities/1/activities/1/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/activities/1/activities/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/activities/1/activities").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify do
          expect(patch: "/activities/1/activities/1").not_to be_routable
        end

        specify { expect(put: "/activities/1/activities/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/activities/1/activities/1").not_to be_routable
      end
    end
  end
end
