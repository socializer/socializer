# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe People::MessagesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "does not route to #index" do
        expect(get: "/people/1/messages").not_to be_routable
      end

      it "routes to #new" do
        expect(get: "/people/1/messages/new")
          .to route_to("socializer/people/messages#new", id: "1")
      end

      it "does not route to #show" do
        expect(get: "/people/1/messages/1/show").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/people/1/messages/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/people/1/messages").not_to be_routable
      end

      it "does not route to #update" do
        expect(patch: "/people/1/messages/1").not_to be_routable
        expect(put: "/people/1/messages/1").not_to be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/people/1/messages/1").not_to be_routable
      end
    end
  end
end
