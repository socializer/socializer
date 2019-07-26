# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Authentication, type: :model do
    let(:authentication) { build(:authentication) }

    it "has a valid factory" do
      expect(authentication).to be_valid
    end

    context "with relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "with validations" do
      it { is_expected.to validate_presence_of(:person) }
      it { is_expected.to validate_presence_of(:provider) }
      it { is_expected.to validate_presence_of(:uid) }
    end

    context "with scopes" do
      describe "with_provider" do
        before { create(:authentication, provider: "identity") }

        let(:result) { described_class.with_provider(provider: "identity") }

        it { expect(result).to be_kind_of(ActiveRecord::Relation) }
        it { expect(result.first.provider).to eq("identity") }

        context "when the provider is not found" do
          let(:result) { described_class.with_provider(provider: "none") }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.exists?).to be(false) }
        end
      end

      describe "not_with_provider" do
        before { create(:authentication, provider: "identity") }

        let(:result) { described_class.not_with_provider(provider: "identity") }

        it { expect(result).to be_kind_of(ActiveRecord::Relation) }
        it { expect(result.exists?).to be(false) }
      end
    end

    context "when last authentication for a person" do
      let(:last_authentication) { create(:authentication) }

      it { expect(last_authentication.person.authentications.count).to eq(1) }

      describe "it cannot be deleted" do
        before do
          last_authentication.destroy
        end

        it { expect(last_authentication.destroyed?).to be false }
        it { expect(last_authentication.errors.present?).to be true }
        it { expect(last_authentication.person.authentications.count).to eq(1) }
      end
    end
  end
end
