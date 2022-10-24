# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe NotesController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "does not route to #index" do
        expect(get: "/notes").not_to be_routable
      end

      it "routes to #new" do
        expect(get: "/notes/new").to route_to("socializer/notes#new")
      end

      it "does not route to #show" do
        expect(get: "/notes/1").not_to be_routable
      end

      it "routes to #edit" do
        expect(get: "/notes/1/edit")
          .to route_to("socializer/notes#edit", id: "1")
      end

      it "routes to #create" do
        expect(post: "/notes")
          .to route_to("socializer/notes#create")
      end

      it "routes to #update" do
        expect(patch: "/notes/1")
          .to route_to("socializer/notes#update", id: "1")
      end

      it "routes to #destroy" do
        expect(delete: "/notes/1")
          .to route_to("socializer/notes#destroy", id: "1")
      end
    end
  end
end
