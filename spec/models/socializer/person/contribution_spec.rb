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
      specify { is_expected.to validate_presence_of(:label) }
      specify { is_expected.to validate_presence_of(:url) }
    end

    specify do
      expect(contribution).to enumerize(:label)
        .in(:current_contributor, :past_contributor)
        .with_default(:current_contributor)
        .with_predicates(true)
        .with_scope(true)
    end
  end
end
