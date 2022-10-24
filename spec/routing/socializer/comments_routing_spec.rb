# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe CommentsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "does not route to #index" do
        expect(get: "/comments").not_to be_routable
      end

      it "routes to #new" do
        expect(get: "/comments/new").to route_to("socializer/comments#new")
      end

      it "does not route to #show" do
        expect(get: "/comments/1").not_to be_routable
      end

      it "routes to #edit" do
        expect(get: "/comments/1/edit")
          .to route_to("socializer/comments#edit", id: "1")
      end

      it "routes to #create" do
        expect(post: "/comments")
          .to route_to("socializer/comments#create")
      end

      it "routes to #update" do
        expect(patch: "/comments/1")
          .to route_to("socializer/comments#update", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/comments/1")
          .to route_to("socializer/comments#destroy", id: "1")
      end
    end
  end
end
