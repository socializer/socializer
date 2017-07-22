# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Link, type: :model do
    let(:link) { build(:person_link) }

    it "has a valid factory" do
      expect(link).to be_valid
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:display_name) }
      it { is_expected.to validate_presence_of(:person) }
      it { is_expected.to validate_presence_of(:url) }
    end
  end
end
