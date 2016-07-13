# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circles::ContactOfController, type: :routing do
    routes { Socializer::Engine.routes }

    describe "routing" do
      it "routes to #index" do
        expect(get: "/circles/contact_of")
          .to route_to("socializer/circles/contact_of#index")
      end

      it "does not route to #new" do
        expect(get: "/circles/contact_of/new").not_to be_routable
      end

      it "does not route to #show" do
        expect(get: "/circles/contact_of/show/1").not_to be_routable
      end

      it "does not route to #edit" do
        expect(get: "/circles/contact_of/1/edit").not_to be_routable
      end

      it "does not route to #create" do
        expect(post: "/circles/contact_of").not_to be_routable
      end

      it "does not route to #update" do
        expect(patch: "/circles/contact_of/1").not_to be_routable
        expect(put: "/circles/contact_of/1").not_to be_routable
      end

      it "does not route to #destroy" do
        expect(delete: "/circles/contact_of/1").not_to be_routable
      end
    end
  end
end
