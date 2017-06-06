# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe CreateActivity, type: :model do
    let(:ac) { CreateActivity.new }
    let(:activity_object) { create(:activity_object) }
    let(:person) { create(:person) }

    let(:activity_attributes) do
      { actor_id: person.id,
        activity_object_id: activity_object.id,
        verb: "post" }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:actor_id) }
      it { is_expected.to validate_presence_of(:activity_object_id) }
      it { is_expected.to validate_presence_of(:verb) }

      it { expect(ac.valid?).to be false }
    end

    context ".call" do
      context "with no required attributes" do
        it { expect(ac.call).to be_kind_of(Activity) }
        it { expect(ac.call.persisted?).to be false }
      end

      context "with the required attributes" do
        let(:ac) { CreateActivity.new(activity_attributes) }

        it { expect(ac.valid?).to be true }
        it { expect(ac.call).to be_kind_of(Activity) }
        it { expect(ac.call.persisted?).to be true }
      end

      context "#object_ids" do
        let(:ac) { CreateActivity.new(activity_attributes) }

        let(:public_privacy) do
          Socializer::Audience.privacy.find_value(:public).value
        end

        let(:circles_privacy) do
          Socializer::Audience.privacy.find_value(:circles).value
        end

        let(:activity_attributes) do
          { actor_id: person.id,
            activity_object_id: activity_object.id,
            object_ids: object_ids,
            verb: "post" }
        end

        let(:results) { ac.call }
        let(:public_audience) { results.audiences.where(privacy: "public") }
        let(:circles_audience) { results.audiences.where(privacy: "circles") }

        context "as a String" do
          let(:object_ids) { public_privacy }

          it { expect(results.persisted?).to eq(true) }
          it { expect(public_audience.present?).to eq(true) }
          it { expect(circles_audience.present?).to eq(false) }
        end

        context "as an Array" do
          let(:object_ids) { [public_privacy, circles_privacy] }

          it { expect(results.persisted?).to eq(true) }
          it { expect(public_audience.present?).to eq(true) }
          it { expect(circles_audience.present?).to eq(true) }
        end
      end
    end
  end
end
