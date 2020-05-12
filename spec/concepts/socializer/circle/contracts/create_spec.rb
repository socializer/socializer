# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circle::Contracts::Create, type: :contract do
    let(:contract) { described_class.new(record: record, actor: actor) }
    let(:result) { contract.call(attributes).to_monad }
    let(:actor) { create(:person) }
    let(:record) { Socializer::Circle.new }

    let(:attributes) do
      { display_name: "Display Name", content: "Some content." }
    end

    context "when record is not specified" do
      let(:contract) { described_class.new(actor: actor) }

      it { expect(result).to be_success }
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

    context "when display_name is not unique" do
      let(:circles) { actor.activity_object.circles }
      let(:circle) { circles.create!(attributes) }
      let(:failure) { result.failure }

      before do
        circle
      end

      it { expect(result).to be_failure }
      it { expect(failure.success?).to be false }

      it { expect(failure.errors).not_to be_nil }
    end
  end
end
