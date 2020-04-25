# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity::Contracts::Share, type: :contract do
    let(:result) { subject.call(attributes) }

    context "when attributes are specified" do
      let(:attributes) do
        { actor_id: 1,
          activity_object_id: 1,
          verb: "share",
          object_ids: "public",
          content: "share" }
      end

      it "is valid" do
        expect(result).to be_success
      end
    end

    context "when attributes are not specified" do
      let(:attributes) { { } }

      it { expect(result).to be_failure }
      it { expect(result.errors[:actor_id]).to eq(["is missing"]) }

      it do
        expect(result.errors[:activity_object_id]).to eq(["is missing"])
      end

      it { expect(result.errors[:verb]).to eq(["is missing"]) }
      it { expect(result.errors[:object_ids]).to eq(["is missing"]) }
      it { expect(result.errors[:content]).to eq(["is missing"]) }
    end
  end
end