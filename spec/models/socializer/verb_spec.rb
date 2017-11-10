# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb, type: :model do
    let(:verb) { build(:verb) }

    it "has a valid factory" do
      expect(verb).to be_valid
    end

    context "with relationships" do
      it { is_expected.to have_many(:activities) }
    end

    context "with validations" do
      subject { verb }

      it { is_expected.to validate_presence_of(:display_name) }
      it { is_expected.to validate_uniqueness_of(:display_name) }
    end

    context "with scopes" do
      describe "with_display_name" do
        before { create(:verb, display_name: "post") }
        let(:result) { Verb.with_display_name(name: "post") }

        it { expect(result).to be_kind_of(ActiveRecord::Relation) }
        it { expect(result.first.display_name).to eq("post") }

        context "when the name is not found" do
          let(:result) { Verb.with_display_name(name: "none") }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.exists?).to be(false) }
        end
      end
    end
  end
end
