# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Contribution, type: :model do
    let(:contribution) { build(:person_contribution) }

    it "has a valid factory" do
      expect(contribution).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:display_name) }
      it { is_expected.to allow_mass_assignment_of(:label) }
      it { is_expected.to allow_mass_assignment_of(:url) }
      it { is_expected.to allow_mass_assignment_of(:current) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:display_name) }
      it { is_expected.to validate_presence_of(:label) }
      it { is_expected.to validate_presence_of(:person) }
      it { is_expected.to validate_presence_of(:url) }
    end

    it do
      is_expected.to enumerize(:label)
        .in(:current_contributor, :past_contributor)
        .with_default(:current_contributor)
        .with_predicates(true)
        .with_scope(true)
    end
  end
end
