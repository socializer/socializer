# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Address, type: :model do
    let(:address) { build(:person_address) }

    it "has a valid factory" do
      expect(address).to be_valid
    end

    context "with relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "with validations" do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to validate_presence_of(:person) }
      it { is_expected.to validate_presence_of(:line1) }
      it { is_expected.to validate_presence_of(:city) }
      it { is_expected.to validate_presence_of(:province_or_state) }
      it { is_expected.to validate_presence_of(:postal_code_or_zip) }
      it { is_expected.to validate_presence_of(:country) }
    end

    it do
      expect(address).to enumerize(:category)
        .in(:home, :work)
        .with_default(:home)
        .with_predicates(true)
        .with_scope(true)
    end
  end
end
