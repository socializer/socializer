# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circle::Operations::Create, type: :operation do
    let(:operation) { described_class.new(actor: actor) }
    let(:result) { operation.call(params: attributes) }
    let(:actor) { create(:person) }
    let(:display_name) { "Friends" }
    let(:content) { "Some content." }
    let(:failure) { result.failure }

    let(:attributes) do
      { display_name: display_name, content: content }
    end

    describe ".call" do
      context "with no required attributes" do
        let(:display_name) { nil }
        let(:failure) { result.failure }

        it { expect(result).to be_failure }
        it { expect(failure.success?).to be false }

        specify { expect(result).to be_failure }
        specify { expect(failure.success?).to be false }
        specify { expect(failure.errors).not_to be_nil }
      end

      context "with required attributes" do
        let(:success) { result.success[:circle] }
        let(:notice) { result.success[:notice] }
        let(:model) { success.class.name.demodulize }
        let(:notice_i18n) { I18n.t("socializer.model.create", model: model) }

        specify { expect(result).to be_success }
        specify { expect(circle.valid?).to be true }
        specify { expect(circle).to be_kind_of(Circle) }
        specify { expect(circle.persisted?).to be true }

        specify do
          model = circle.class.name.demodulize
          notice_i18n = I18n.t("socializer.model.create", model: model)
          expect(result.success[:notice]).to eq(notice_i18n)
        end
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
end
