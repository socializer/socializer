# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe People::ActivitiesController, type: :routing do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/people/1/activities")
          .to route_to("socializer/people/activities#index", person_id: "1")
      end

      it "does not route to #new" do
        expect(get: "/people/1/activities/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/people/1/activities/1/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/people/1/activities/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/people/1/activities").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/people/1/activities/1").not_to be_routable }
        specify { expect(put: "/people/1/activities/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/people/1/activities/1").not_to be_routable
      end
    end
  end
end
