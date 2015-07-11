require "rails_helper"

module Socializer
  RSpec.describe PersonEducation, type: :model do
    let(:person_education) { build(:person_education) }

    it "has a valid factory" do
      expect(person_education).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:school_name) }
      it { is_expected.to allow_mass_assignment_of(:major_or_field_of_study) }
      it { is_expected.to allow_mass_assignment_of(:started_on) }
      it { is_expected.to allow_mass_assignment_of(:ended_on) }
      it { is_expected.to allow_mass_assignment_of(:current) }
      it { is_expected.to allow_mass_assignment_of(:courses_description) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:person) }
    end
  end
end
