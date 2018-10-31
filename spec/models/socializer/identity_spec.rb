# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Identity, type: :model do
    let(:identity) { build(:identity) }

    it "has a valid factory" do
      expect(identity).to be_valid
    end

    context "with validations" do
      subject { identity }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email) }
      it { is_expected.to validate_presence_of(:password_digest) }
    end

    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
  end
end
