# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Education do
    let(:education) { build(:person_education) }

    it "has a valid factory" do
      expect(education).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:educations) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:school_name) }
      specify { is_expected.to validate_presence_of(:started_on) }
    end
  end
end
