# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Comment::Operations::Create, type: :operation do
    let(:result) { described_class.new(actor: actor).call(params: attributes) }
    let(:actor) { create(:person) }

    let(:attributes) do
      { activity_verb: Types::ActivityVerbs["add"],
        content: "Some Content" }
    end

    describe ".call" do
      context "with no required attributes" do
        let(:attributes) { { } }
        let(:errors) { result.failure.errors }

        specify { expect(result).to be_failure }
        specify { expect(result).to be_kind_of(Dry::Monads::Result::Failure) }
        specify { expect(result.failure.success?).to be false }

        specify { expect(errors).not_to be_nil }
        # FIXME: Use I18n
        specify { expect(errors[:content]).to eq(["is missing"]) }
      end

      context "with required attributes" do
        let(:comment) { result.success[:comment] }

        let(:notice_i18n) do
          I18n.t("socializer.model.create",
                 model: comment.class.name.demodulize)
        end

        specify { expect(result).to be_success }
        specify { expect(comment.valid?).to be true }
        specify { expect(comment).to be_kind_of(Comment) }
        specify { expect(comment.persisted?).to be true }
        specify { expect(result.success[:notice]).to eq(notice_i18n) }
      end
    end
  end
end
