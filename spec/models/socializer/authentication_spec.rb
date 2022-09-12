# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Authentication, type: :model do
    let(:authentication) { build(:authentication) }

    it "has a valid factory" do
      expect(authentication).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:provider) }
      specify { is_expected.to validate_presence_of(:uid) }
    end

    context "with scopes" do
      describe "with_provider" do
        before { create(:authentication, provider: "identity") }

        let(:result) { described_class.with_provider(provider: "identity") }

        specify { expect(result).to be_a(ActiveRecord::Relation) }
        specify { expect(result.first.provider).to eq("identity") }

        context "when the provider is not found" do
          let(:result) { described_class.with_provider(provider: "none") }

          specify { expect(result).to be_a(ActiveRecord::Relation) }
          specify { expect(result.exists?).to be(false) }
        end
      end

      describe "not_with_provider" do
        before { create(:authentication, provider: "identity") }

        let(:result) { described_class.not_with_provider(provider: "identity") }

        specify { expect(result).to be_a(ActiveRecord::Relation) }
        specify { expect(result.exists?).to be(false) }
      end
    end

    context "when last authentication for a person" do
      let(:last_authentication) { create(:authentication) }

      specify do
        expect(last_authentication.person.authentications.count).to eq(1)
      end

      describe "it cannot be deleted" do
        before do
          last_authentication.destroy
        end

        specify { expect(last_authentication.destroyed?).to be false }
        specify { expect(last_authentication.errors.present?).to be true }

        specify do
          expect(last_authentication.person.authentications.count).to eq(1)
        end
      end
    end
  end
end
