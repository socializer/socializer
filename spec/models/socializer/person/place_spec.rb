# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person::Place, type: :model do
    let(:place) { build(:person_place) }

    it "has a valid factory" do
      expect(place).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:city_name) }
      it { is_expected.to allow_mass_assignment_of(:current) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:person) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:city_name) }
      it { is_expected.to validate_presence_of(:person) }
    end

    context "scopes" do
      context "current and previous" do
        let(:place) { create(:person_place) }

        before { place }

        context "with only current record" do
          it "current.present? should be true" do
            expect(Person::Place.current.present?).to eq(true)
          end

          it "previous.empty? should be true" do
            expect(Person::Place.previous.empty?).to eq(true)
          end
        end

        context "with current and previous records" do
          let(:not_current_place) { create(:person_place, current: false) }

          before { not_current_place }

          it "current.present? should be true" do
            expect(Person::Place.current.present?).to eq(true)
          end

          it "previous.present? should be true" do
            expect(Person::Place.previous.present?).to eq(true)
          end
        end
      end
    end
  end
end
