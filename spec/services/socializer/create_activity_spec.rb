# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe CreateActivity, type: :model do
    let(:ac) { described_class.new }

    let(:activity_attributes) do
      { actor_id: person.id,
        activity_object_id: activity_object.id,
        verb: "post" }
    end

    context "with validations" do
      it { is_expected.to validate_presence_of(:actor_id) }
      it { is_expected.to validate_presence_of(:activity_object_id) }
      it { is_expected.to validate_presence_of(:verb) }

      it { expect(ac.valid?).to be false }
    end

    describe ".call" do
      context "with no required attributes" do
        it { expect(ac.call).to be_a(Activity) }
        it { expect(ac.call.persisted?).to be false }
      end

      context "with the required attributes" do
        let(:person) { create(:person) }
        let(:activity_object) { create(:activity_object) }
        let(:ac) { described_class.new(activity_attributes) }

        it { expect(ac.valid?).to be true }
        it { expect(ac.call).to be_a(Activity) }
        it { expect(ac.call.persisted?).to be true }
      end
    end
  end
end
