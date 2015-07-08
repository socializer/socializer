require "rails_helper"

module Socializer
  RSpec.describe PersonPlace, type: :model do
    let(:person_place) { build(:socializer_person_place) }

    it "has a valid factory" do
      expect(person_place).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:city_name) }
      it { is_expected.to allow_mass_assignment_of(:current) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:city_name) }
      it { is_expected.to validate_presence_of(:person) }
    end
  end
end
