# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb, type: :model do
    let(:verb) { build(:verb) }

    it "has a valid factory" do
      expect(verb).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to have_many(:activities) }
    end

    context "with validations" do
      subject { verb }

      specify { is_expected.to validate_presence_of(:display_name) }
      specify { is_expected.to validate_uniqueness_of(:display_name) }
    end

    context "with scopes" do
      describe "with_display_name" do
        before { create(:verb, display_name: "post") }

        let(:result) { described_class.with_display_name(name: "post") }

        specify { expect(result).to be_a(ActiveRecord::Relation) }
        specify { expect(result.first.display_name).to eq("post") }

        context "when the name is not found" do
          let(:result) { described_class.with_display_name(name: "none") }

          specify { expect(result).to be_a(ActiveRecord::Relation) }
          specify { expect(result.exists?).to be(false) }
        end
      end
    end
  end
end
