require "rails_helper"

module Socializer
  RSpec.describe Group::Link, type: :model do
    let(:group_link) { build(:group_link) }

    it "has a valid factory" do
      expect(group_link).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:label) }
      it { is_expected.to allow_mass_assignment_of(:url) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:group) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:group) }
      it { is_expected.to validate_presence_of(:label) }
      it { is_expected.to validate_presence_of(:url) }
    end
  end
end
