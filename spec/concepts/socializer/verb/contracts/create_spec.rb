# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb::Contracts::Create, type: :contract do
    let(:result) { subject.call(attributes) }

    context "when attributes are specified" do
      let(:attributes) do
        { display_name: "unlike" }
      end

      it "is valid" do
        expect(result).to be_success
      end
    end

    context "when attributes are not specified" do
      let(:attributes) { { } }

      it { expect(result).to be_failure }
      it { expect(result.errors[:display_name]).to eq(["is missing"]) }
    end

    context "when attributes are invalid" do
      let(:attributes) do
        { display_name: "bob" }
      end

      let(:valid_verbs) { Types::ActivityVerbs }

      it { expect(result).to be_failure }

      it do
        expect(result.errors[:display_name])
          .to eq(["must be one of: #{valid_verbs.values.join(', ')}"])
      end
    end
  end
end
