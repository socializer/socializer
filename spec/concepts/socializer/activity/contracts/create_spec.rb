# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity::Contracts::Create, type: :contract do
    let(:result) { subject.call(attributes) }
    let(:verb) { build(:verb) }

    let(:public_privacy) do
      Socializer::Audience.privacy.find_value(:public).value
    end

    let(:object_ids) { public_privacy }

    let(:attributes) do
      { actor_id: 1,
        activity_object_id: 1,
        verb: verb,
        object_ids: object_ids,
        content: "share" }
    end

    context "when attributes are specified" do
      it "is valid" do
        expect(result).to be_success
      end
    end

    context "when attributes are not specified" do
      let(:attributes) { { } }

      specify { expect(result).to be_failure }
      specify { expect(result.errors[:actor_id]).to eq(["is missing"]) }

      it do
        expect(result.errors[:activity_object_id]).to eq(["is missing"])
      end

      specify { expect(result.errors[:verb]).to eq(["is missing"]) }
      specify { expect(result.errors[:object_ids]).to be_nil }
      specify { expect(result.errors[:content]).to be_nil }
    end

    describe "when #object_ids is an Integer" do
      context "when the circle does't exist" do
        let(:object_ids) { 1 }

        specify { expect(result).to be_failure }
      end

      context "when the circle exists" do
        let(:circle) { create(:circle) }
        let(:object_ids) { circle.id }

        specify { expect(result).to be_success }
      end
    end

    describe "when #object_ids is an array of Integers" do
      context "when the circles doesn't exist" do
        let(:object_ids) { [1, 2, 3] }

        specify { expect(result).to be_failure }
      end

        let(:circle1) { create(:circle) }
        let(:circle2) { create(:circle) }
        let(:circle3) { create(:circle) }
        let(:object_ids) { [circle1.id, circle2.id, circle3.id] }
      context "when the circles do exists" do

        specify { expect(result).to be_success }
      end
    end
  end
end
