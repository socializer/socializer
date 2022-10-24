# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Group::Category do
    let(:group_category) { build(:group_category) }

    it "has a valid factory" do
      expect(group_category).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:group).inverse_of(:links) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:display_name) }
    end
  end
end
