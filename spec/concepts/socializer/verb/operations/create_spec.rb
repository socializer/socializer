# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Verb::Operations::Create, type: :operation do
    let(:result) { described_class.new.call(params: attributes) }
    let(:display_name) { Types::ActivityVerbs["post"] }

    let(:attributes) do
      { display_name: display_name }
    end

    context "with .call" do
      context "with no required attributes" do
        let(:display_name) { nil }
        let(:failure) { result.failure }

        specify { expect(result).to be_failure }
        specify { expect(result).to be_kind_of(Dry::Monads::Result::Failure) }
        specify { expect(failure.success?).to be false }

        # FIXME: Use I18n
        specify do
          expect(failure.errors[:display_name]).to eq(["must be filled"])
        end
      end

      context "with required attributes" do
        let(:verb) { result.success[:verb] }

        let(:notice_i18n) do
          I18n.t("socializer.model.create",
                 model: verb.class.name.demodulize)
        end

        specify { expect(result).to be_success }
        specify { expect(verb.valid?).to be true }
        specify { expect(verb).to be_kind_of(Verb) }
        specify { expect(verb.persisted?).to be true }
        specify { expect(result.success[:notice]).to eq(notice_i18n) }
      end
    end
  end
end
