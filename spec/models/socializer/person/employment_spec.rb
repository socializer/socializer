# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Employment, type: :model do
    let(:employment) { build(:person_employment) }

    it "has a valid factory" do
      expect(employment).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:employments) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:employer_name) }
      specify { is_expected.to validate_presence_of(:started_on) }
    end
  end
end
