# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Link, type: :model do
    let(:link) { build(:person_link) }

    it "has a valid factory" do
      expect(link).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:links) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:display_name) }
      specify { is_expected.to validate_presence_of(:url) }
    end
  end
end
