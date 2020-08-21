# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb::Contracts::Create, type: :contract do
    let(:contract) { described_class.new(record: record) }
    let(:result) { contract.call(attributes).to_monad }
    let(:record) { Socializer::Verb.new }
    let(:failure) { result.failure }

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

      specify { expect(result).to be_failure }
      specify { expect(failure.success?).to be false }
      specify { expect(failure.errors).not_to be_nil }
    end

    context "when attributes are invalid" do
      let(:attributes) do
        { display_name: "bob" }
      end

      specify { expect(result).to be_failure }
      specify { expect(failure.success?).to be false }
      specify { expect(failure.errors).not_to be_nil }
    end

    context "when display_name is not unique" do
      before do
        Verb.create!(attributes)
      end

      specify { expect(result).to be_failure }
      specify { expect(failure.success?).to be false }
      specify { expect(failure.errors).not_to be_nil }
    end
  end
end
