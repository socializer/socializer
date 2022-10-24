# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Identity do
    let(:identity) { build(:identity) }

    it "has a valid factory" do
      expect(identity).to be_valid
    end

    context "with validations" do
      subject { identity }

      specify { is_expected.to validate_presence_of(:name) }
      specify { is_expected.to validate_presence_of(:email) }
      specify { is_expected.to validate_uniqueness_of(:email) }
      specify { is_expected.to validate_presence_of(:password_digest) }
    end

    specify { is_expected.to respond_to(:password) }
    specify { is_expected.to respond_to(:password_confirmation) }
  end
end
