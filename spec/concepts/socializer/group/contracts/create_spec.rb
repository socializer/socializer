# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Group::Contracts::Create, type: :contract do
    let(:contract) do
      described_class.new(record: Socializer::Group.new, actor: actor)
    end

    let(:actor) { create(:person) }
    let(:result) { contract.call(attributes).to_monad }
    let(:failure) { result.failure }

    let(:attributes) do
      { display_name: "Display Name",
        privacy: Group.privacy.find_value(:public),
        tagline: "Some tagline." }
    end

    context "when attributes are specified" do
      it "is valid" do
        expect(result).to be_success
      end
    end

    context "when record is not specified" do
      let(:contract) { described_class.new(actor: actor) }

      specify { expect(result).to be_success }
    end

    context "when attributes are not specified" do
      let(:attributes) { {} }

      specify { expect(result).to be_failure }
      specify { expect(failure.success?).to be false }
      specify { expect(failure.errors).not_to be_nil }
    end

    context "when display_name is not unique" do
      before do
        groups = actor.activity_object.groups
        groups.create!(attributes)
      end

      specify { expect(result).to be_failure }
      specify { expect(failure.success?).to be false }
      specify { expect(failure.errors).not_to be_nil }
    end
  end
end
