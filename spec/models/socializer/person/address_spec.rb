# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Address, type: :model do
    let(:address) { build(:person_address) }

    it "has a valid factory" do
      expect(address).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:addresses) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:category) }
      specify { is_expected.to validate_presence_of(:line1) }
      specify { is_expected.to validate_presence_of(:city) }
      specify { is_expected.to validate_presence_of(:province_or_state) }
      specify { is_expected.to validate_presence_of(:postal_code_or_zip) }
      specify { is_expected.to validate_presence_of(:country) }
    end

    specify do
      expect(address).to enumerize(:category)
        .in(:home, :work)
        .with_default(:home)
        .with_predicates(true)
        .with_scope(true)
    end
  end
end
