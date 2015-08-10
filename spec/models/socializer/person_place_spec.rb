require "rails_helper"

module Socializer
  RSpec.describe PersonPlace, type: :model do
    let(:person_place) { build(:person_place) }

    it "has a valid factory" do
      expect(person_place).to be_valid
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
        let(:person_place) { create(:person_place) }

        before { person_place }

        context "with only current record" do
          it "current.present? should be true" do
            expect(PersonPlace.current.present?).to eq(true)
          end

          it "previous.empty? should be true" do
            expect(PersonPlace.previous.empty?).to eq(true)
          end
        end

        context "with current and previous records" do
          let(:not_current_place) { create(:person_place, current: false) }

          before { not_current_place }

          it "current.present? should be true" do
            expect(PersonPlace.current.present?).to eq(true)
          end

          it "previous.present? should be true" do
            expect(PersonPlace.previous.present?).to eq(true)
          end
        end
      end
    end
  end
end
