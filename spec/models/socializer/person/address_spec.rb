# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Address, type: :model do
    let(:address) { build(:person_address) }

    it "has a valid factory" do
      expect(address).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:line1) }
      it { is_expected.to allow_mass_assignment_of(:line2) }
      it { is_expected.to allow_mass_assignment_of(:city) }
      it { is_expected.to allow_mass_assignment_of(:postal_code_or_zip) }
      it { is_expected.to allow_mass_assignment_of(:province_or_state) }
      it { is_expected.to allow_mass_assignment_of(:country) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to validate_presence_of(:person) }
      it { is_expected.to validate_presence_of(:line1) }
      it { is_expected.to validate_presence_of(:city) }
      it { is_expected.to validate_presence_of(:province_or_state) }
      it { is_expected.to validate_presence_of(:postal_code_or_zip) }
      it { is_expected.to validate_presence_of(:country) }
    end

    it do
      is_expected.to enumerize(:category).in(:home, :work).with_default(:home)
    end
  end
end
