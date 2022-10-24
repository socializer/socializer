# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe AudienceListsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/audience_lists", format: :json)
          .to route_to("socializer/audience_lists#index")
      end

      it "does not route to #new" do
        expect(get: "/audience_lists/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/audience_lists/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/audience_lists/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/audience_lists").not_to be_routable
      end

      it "does not route to #update" do
        expect(patch: "/audience_lists/1").not_to be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/audience_lists/1").not_to be_routable
      end
    end
  end
end
