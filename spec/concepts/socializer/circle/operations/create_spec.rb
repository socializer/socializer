# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circle::Operations::Create, type: :operation do
    let(:operation) { described_class.new(actor: actor) }
    let(:result) { operation.call(params: attributes) }
    let(:actor) { create(:person) }
    let(:display_name) { "Friends" }
    let(:content) { "Some content." }

    let(:attributes) do
      { display_name: display_name, content: content }
    end

    context "with .call" do
      context "with no required attributes" do
        let(:display_name) { nil }
        let(:failure) { result.failure }

        it { expect(result).to be_failure }
        it { expect(failure.success?).to be false }

        it { expect(failure.errors).not_to be_nil }
      end

      context "with required attributes" do
        let(:success) { result.success[:circle] }
        let(:notice) { result.success[:notice] }
        let(:model) { success.class.name.demodulize }
        let(:notice_i18n) { I18n.t("socializer.model.create", model: model) }

        it { expect(result).to be_success }
        it { expect(success.valid?).to be true }
        it { expect(success).to be_kind_of(Circle) }
        it { expect(success.persisted?).to be true }

        it { expect(notice).to eq(notice_i18n) }
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
end
