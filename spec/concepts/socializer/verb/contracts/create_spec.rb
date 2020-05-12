# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb::Contracts::Create, type: :contract do
    let(:contract) { described_class.new(record: record) }
    let(:result) { contract.call(attributes).to_monad }
    let(:record) { Socializer::Verb.new }

    let(:attributes) do
      { display_name: "unlike" }
    end

    context "when attributes are specified" do
      it "is valid" do
        expect(result).to be_success
      end
    end

    context "when attributes are not specified" do
      let(:attributes) { { } }
      let(:failure) { result.failure }

      it { expect(result).to be_failure }
      it { expect(failure.success?).to be false }

      it { expect(failure.errors).not_to be_nil }
    end

    context "when attributes are invalid" do
      let(:valid_verbs) { Types::ActivityVerbs }
      let(:failure) { result.failure }

      let(:attributes) do
        { display_name: "bob" }
      end

      it { expect(result).to be_failure }
      it { expect(failure.success?).to be false }

      it { expect(failure.errors).not_to be_nil }
    end

    context "when display_name is not unique" do
      let(:verb) { Verb.create!(attributes) }
      let(:failure) { result.failure }

      before do
        verb
      end

      it { expect(result).to be_failure }
      it { expect(failure.success?).to be false }

      it { expect(failure.errors).not_to be_nil }
    end
  end
end
