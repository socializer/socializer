# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circle::Contracts::Create, type: :contract do
    let(:contract) { described_class.new(record: record, actor: actor) }
    let(:result) { contract.call(attributes).to_monad }
    let(:failure) { result.failure }
    let(:actor) { create(:person) }
    let(:record) { Socializer::Circle.new }

    let(:attributes) do
      { display_name: "Display Name", content: "Some content." }
    end

    context "when record is not specified" do
      let(:contract) { described_class.new(actor: actor) }

      specify { expect(result).to be_success }
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

    context "when display_name is not unique" do
      let(:circles) { actor.activity_object.circles }
      let(:circle) { circles.create!(attributes) }
      let(:failure) { result.failure }

      before do
        circle
      end

      specify { expect(result).to be_failure }
      specify { expect(failure.success?).to be false }
      specify { expect(failure.errors).not_to be_nil }
    end
  end
end
