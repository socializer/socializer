require "rails_helper"

module Socializer
  RSpec.describe Circles::ContactsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/circles/contacts")
          .to route_to("socializer/circles/contacts#index")
      end

      it "does not route to #new" do
        expect(get: "/circles/contacts/new").to_not be_routable
      end

      it "does not route to #show" do
        expect(get: "/circles/contacts/show/1").to_not be_routable
      end

      it "does not route to #edit" do
        expect(get: "/circles/contacts/1/edit").to_not be_routable
      end

      it "does not route to #create" do
        expect(post: "/circles/contacts").to_not be_routable
      end

      it "does not route to #update" do
        expect(patch: "/circles/contacts/1").to_not be_routable
        expect(put: "/circles/contacts/1").to_not be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/circles/contacts/1").to_not be_routable
      end
    end
  end
end
