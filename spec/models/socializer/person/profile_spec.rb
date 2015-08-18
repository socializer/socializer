require "rails_helper"

module Socializer
  RSpec.describe Person::Profile, type: :model do
    let(:person_profile) { build(:person_profile) }

    it "has a valid factory" do
      expect(person_profile).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:label) }
      it { is_expected.to allow_mass_assignment_of(:url) }
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
