# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Contribution do
    let(:contribution) { build(:person_contribution) }

    it "has a valid factory" do
      expect(contribution).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:contributions) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:display_name) }
      specify { is_expected.to validate_presence_of(:url) }
    end

    specify do
      is_expected.to define_enum_for(:label)
        .with_values(current_contributor: 1, past_contributor: 2)
        .backed_by_column_of_type(:integer)
        .with_prefix
        .with_default(:current_contributor)
        .validating(allowing_nil: false)
    end
  end
end
