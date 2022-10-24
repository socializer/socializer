# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Place do
    let(:place) { build(:person_place) }

    it "has a valid factory" do
      expect(place).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:person).inverse_of(:places) }
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:city_name) }
    end

    context "with scopes" do
      describe "current and previous" do
        let(:place) { create(:person_place) }

        before { place }

        context "with only current record" do
          it "current.present? should be true" do
            expect(described_class.current.present?).to be(true)
          end

          it "previous.empty? should be true" do
            expect(described_class.previous.empty?).to be(true)
          end
        end

        context "with current and previous records" do
          let(:not_current_place) { create(:person_place, current: false) }

          before { not_current_place }

          it "current.present? should be true" do
            expect(described_class.current.present?).to be(true)
          end

          it "previous.present? should be true" do
            expect(described_class.previous.present?).to be(true)
          end
        end
      end
    end
  end
end
