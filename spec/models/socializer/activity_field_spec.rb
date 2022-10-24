# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ActivityField do
    let(:activity_field) { build(:activity_field) }

    it "has a valid factory" do
      expect(activity_field).to be_valid
    end

    context "with relationships" do
      specify do
        expect(activity_field).to belong_to(:activity)
          .inverse_of(:activity_field)
      end
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:content) }
    end
  end
end
