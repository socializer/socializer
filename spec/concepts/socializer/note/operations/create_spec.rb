# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Note::Operations::Create, type: :service do
    let(:note) { described_class.new(actor: actor) }
    let(:result) { note.call(params: attributes) }
    let(:activity_verb) { Types::ActivityVerbs["post"] }
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
        let(:failure) { result.failure[:note] }
        let(:errors) { result.failure[:errors] }

        it { expect(result).to be_failure }
        it { expect(failure.valid?).to be false }
        it { expect(failure).to be_kind_of(Note) }
        it { expect(failure.persisted?).to be false }

        it { expect(errors).not_to be_nil }
        # FIXME: Use I18n
        it { expect(errors[:activity_verb]).to eq(["is missing"]) }
        it { expect(errors[:object_ids]).to eq(["is missing"]) }
        it { expect(errors[:content]).to eq(["is missing"]) }
      end

      context "with required attributes" do
        let(:success) { result.success[:note] }
        let(:notice) { result.success[:notice] }
        let(:model) { success.class.name.demodulize }
        let(:notice_I18n) { I18n.t("socializer.model.create", model: model) }

        it { expect(result).to be_success }
        it { expect(success.valid?).to be true }
        it { expect(success).to be_kind_of(Note) }
        it { expect(success.persisted?).to be true }

        it { expect(notice).to be_a String }
        it { expect(notice).not_to be_nil }
        it { expect(notice).to eq(notice_I18n) }
      end
    end
  end
end
