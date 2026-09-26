# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Address do
    let(:address) { build(:person_address) }

    it "has a valid factory" do
      expect(address).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:addresses) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:line1) }
      specify { is_expected.to validate_presence_of(:city) }
      specify { is_expected.to validate_presence_of(:province_or_state) }
      specify { is_expected.to validate_presence_of(:postal_code_or_zip) }
      specify { is_expected.to validate_presence_of(:country) }
    end

    specify do
      is_expected.to define_enum_for(:category)
        .with_values(home: 1, work: 2)
        .backed_by_column_of_type(:integer)
        .with_prefix
        .with_default(:home)
        .validating(allowing_nil: false)
    end
  end
end
