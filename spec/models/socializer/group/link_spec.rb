# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Group::Link, type: :model do
    let(:group_link) { build(:group_link) }

    it "has a valid factory" do
      expect(group_link).to be_valid
    end

    context "with relationships" do
      it { is_expected.to belong_to(:group) }
    end

    context "with validations" do
      it { is_expected.to validate_presence_of(:group) }
      it { is_expected.to validate_presence_of(:display_name) }
      it { is_expected.to validate_presence_of(:url) }
    end
  end
end
