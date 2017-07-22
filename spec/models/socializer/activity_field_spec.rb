# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ActivityField, type: :model do
    let(:activity_field) { build(:activity_field) }

    it "has a valid factory" do
      expect(activity_field).to be_valid
    end

    context "relationships" do
      it { is_expected.to belong_to(:activity) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_presence_of(:activity) }
    end
  end
end
