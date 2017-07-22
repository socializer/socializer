# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Education, type: :model do
    let(:education) { build(:person_education) }

    it "has a valid factory" do
      expect(education).to be_valid
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:person) }
      it { is_expected.to validate_presence_of(:school_name) }
      it { is_expected.to validate_presence_of(:started_on) }
    end
  end
end
