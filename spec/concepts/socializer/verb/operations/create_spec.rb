# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb::Operations::Create, type: :service do
    let(:verb) { described_class.new }
    let(:result) { verb.call(params: attributes) }
    let(:display_name) { Types::ActivityVerbs["post"] }

    let(:attributes) do
      { display_name: display_name }
    end

    context "with .call" do
      context "with no required attributes" do
        let(:display_name) { nil }
        let(:failure) { result.failure }
        let(:errors) { result.failure.errors }

        it { expect(result).to be_failure }
        it { expect(result).to be_kind_of(Dry::Monads::Result::Failure) }
        it { expect(failure.success?).to be false }

        # FIXME: Use I18n
        it { expect(errors[:display_name]).to eq(["must be filled"]) }
      end

      context "with required attributes" do
        let(:success) { result.success[:verb] }
        let(:notice) { result.success[:notice] }
        let(:model) { success.class.name.demodulize }
        let(:notice_I18n) { I18n.t("socializer.model.create", model: model) }

        it { expect(result).to be_success }
        it { expect(success.valid?).to be true }
        it { expect(success).to be_kind_of(Verb) }
        it { expect(success.persisted?).to be true }

        it { expect(notice).to be_a String }
        it { expect(notice).not_to be_nil }
        it { expect(notice).to eq(notice_I18n) }
      end
    end
  end
end
