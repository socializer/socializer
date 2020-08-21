# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Note::Operations::Create, type: :operation do
    let(:note) { described_class.new(actor: actor) }
    let(:activity_verb) { Types::ActivityVerbs["post"] }
    let(:result) { described_class.new(actor: actor).call(params: attributes) }
    let(:actor) { create(:person) }

    let(:public_privacy) do
      Socializer::Audience.privacy.find_value(:public).value
    end

    let(:object_ids) { public_privacy }
    let(:content) { "Some Content" }

    let(:attributes) do
      { activity_verb: activity_verb,
        object_ids: object_ids,
        content: content }
    end

    context "with .call" do
      context "with no required attributes" do
        let(:attributes) { { } }
        let(:failure) { result.failure }
        let(:errors) { result.failure.errors }

        specify { expect(result).to be_failure }
        specify { expect(result).to be_kind_of(Dry::Monads::Result::Failure) }
        specify { expect(result.failure.success?).to be false }

        specify { expect(errors).not_to be_nil }
        # FIXME: Use I18n
        specify { expect(errors[:object_ids]).to eq(["is missing"]) }
        specify { expect(errors[:content]).to eq(["is missing"]) }
      end

      context "with required attributes" do
        let(:note) { result.success[:note] }

        let(:notice_i18n) do
          I18n.t("socializer.model.create",
                 model: note.class.name.demodulize)
        end

        specify { expect(result).to be_success }
        specify { expect(note.valid?).to be true }
        specify { expect(note).to be_kind_of(Note) }
        specify { expect(note.persisted?).to be true }
        specify { expect(result.success[:notice]).to eq(notice_i18n) }
      end
    end
  end
end
