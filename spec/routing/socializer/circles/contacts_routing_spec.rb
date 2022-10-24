# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circles::ContactsController do
    routes { Socializer::Engine.routes }

    context "with routing" do
      it "routes to #index" do
        expect(get: "/circles/contacts")
          .to route_to("socializer/circles/contacts#index")
      end

      it "does not route to #new" do
        expect(get: "/circles/contacts/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/circles/contacts/show/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/circles/contacts/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/circles/contacts").not_to be_routable
      end

      context "when specify does not route to #update" do
        specify { expect(patch: "/circles/contacts/1").not_to be_routable }
        specify { expect(put: "/circles/contacts/1").not_to be_routable }
      end

      it "does not route to #destroy" do
        expect(delete: "/circles/contacts/1").not_to be_routable
      end
    end
  end
end
