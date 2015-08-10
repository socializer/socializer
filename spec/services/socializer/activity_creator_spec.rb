require "rails_helper"

module Socializer
  RSpec.describe ActivityCreator, type: :service do
    let(:ac) { ActivityCreator.new }

    let(:activity_attributes) do
      { actor_id: person.id,
        activity_object_id: activity_object.id,
        verb: "post"
      }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:actor_id) }
      it { is_expected.to validate_presence_of(:activity_object_id) }
      it { is_expected.to validate_presence_of(:verb) }

      it { expect(ac.valid?).to be false }
    end

    context ".call" do
      context "with no required attributes it should raise RecordInvalid" do
        it { expect { ac.call }.to raise_error(RecordInvalid) }
      end

      context "with the required attributes" do
        let(:person) { create(:person) }
        let(:activity_object) { create(:activity_object) }
        let(:ac) { ActivityCreator.new(activity_attributes) }

        it { expect(ac.valid?).to be true }
        it { expect(ac.call).to be_kind_of(Activity) }
        it { expect(ac.call.persisted?).to be true }
      end
    end
  end
end
