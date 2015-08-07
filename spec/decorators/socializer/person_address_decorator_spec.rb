require "rails_helper"
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonAddressDecorator, type: :decorator do
    let(:address) { create(:person_address) }
    let(:decorated_address) { PersonAddressDecorator.new(address) }

    describe "city_province_or_state_postal_code" do
      let(:result) { "Imogeneborough, California 58517" }

      it do
        expect(decorated_address.city_province_or_state_postal_code)
          .to eq(result)
      end
    end
  end
end
