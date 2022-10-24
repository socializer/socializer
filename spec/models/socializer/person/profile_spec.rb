# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Profile do
    let(:profile) { build(:person_profile) }

    it "has a valid factory" do
      expect(profile).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:profiles) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:display_name) }
      specify { is_expected.to validate_presence_of(:url) }
    end
  end
end
