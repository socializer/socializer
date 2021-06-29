# frozen_string_literal: true

require "rails_helper"
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe Person::AddressDecorator, type: :decorator do
    let(:address) { create(:person_address) }
    let(:decorated_address) { described_class.new(address) }

    describe "formatted_address" do
      context "with no line2" do
        let(:address_value) do
          "282 Kevin Brook<br>" \
            "Imogeneborough, California 58517<br>US"
        end

        specify do
          expect(decorated_address.formatted_address).to eq(address_value)
        end
      end

      context "with line2" do
        let(:address) { create(:person_address, line2: "Apt. 123") }

        let(:address_value) do
          "282 Kevin Brook<br>" \
            "Apt. 123<br>Imogeneborough, California 58517<br>" \
            "US"
        end

        specify do
          expect(decorated_address.formatted_address).to eq(address_value)
        end
      end
    end

    describe "city_province_or_state_postal_code" do
      let(:result) { "Imogeneborough, California 58517" }

      specify do
        expect(decorated_address.city_province_or_state_postal_code)
          .to eq(result)
      end
    end
  end
end
