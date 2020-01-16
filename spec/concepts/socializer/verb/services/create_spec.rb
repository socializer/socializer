# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb::Services::Create, type: :service do
    let(:verb) { described_class.new }
    let(:result) { verb.call(params: attributes) }
    let(:display_name) { Types::ActivityVerbs["post"] }

    let(:attributes) do
      { display_name: display_name }
    end

    context "with .call" do
      context "with no required attributes" do
        let(:display_name) { nil }
        let(:failure) { result.failure[:verb] }
        let(:errors) { result.failure[:errors] }

        it { expect(result).to be_failure }
        it { expect(failure.valid?).to be false }
        it { expect(failure).to be_kind_of(Verb) }
        it { expect(failure.persisted?).to be false }

        it { expect(errors[:display_name]).to eq(["must be filled"]) }
      end

      context "with required attributes" do
        let(:success) { result.success[:verb] }
        let(:notice) { result.success[:notice] }

        it { expect(result).to be_success }
        it { expect(success.valid?).to be true }
        it { expect(success).to be_kind_of(Verb) }
        it { expect(success.persisted?).to be true }

        it { expect(notice).to be_a String }
        it { expect(notice).not_to be_nil }
        it { expect(notice).to eq("Verb was successfully created.") }

      end
    end
  end
end
