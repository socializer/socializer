require "rails_helper"

module Socializer
  RSpec.describe PersonContribution, type: :model do
    let(:person_contribution) { build(:person_contribution) }

    it "has a valid factory" do
      expect(person_contribution).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:label) }
      it { is_expected.to allow_mass_assignment_of(:url) }
      it { is_expected.to allow_mass_assignment_of(:current) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:label) }
      it { is_expected.to validate_presence_of(:person) }
      it { is_expected.to validate_presence_of(:url) }
    end
  end
end
