# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe People::LikesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/people/1/likes")
          .to route_to("socializer/people/likes#index", id: "1")
      end

      it "does not route to #new" do
        expect(get: "/people/1/likes/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/people/1/likes/1/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/people/1/likes/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/people/1/likes").not_to be_routable
      end

      it "does not route to #update" do
        expect(patch: "/people/1/likes/1").not_to be_routable
        expect(put: "/people/1/likes/1").not_to be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/people/1/likes/1").not_to be_routable
      end
    end
  end
end
