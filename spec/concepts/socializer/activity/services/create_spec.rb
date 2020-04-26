# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity::Services::Create, type: :service do
    let(:activity) { described_class.new(actor: actor) }
    let(:activity_object) { create(:activity_object) }
    let(:actor) { create(:person) }
    let(:object_ids) { { } }
    let(:verb) { build(:verb, display_name: "post").display_name }
    let(:result) { activity.call(params: attributes) }

    let(:attributes) do
      { actor_id: actor.guid,
        activity_object_id: activity_object.id,
        verb: verb }
    end

    context "with .call" do
      context "with no required attributes" do
        let(:attributes) {}
        let(:failure) { result.failure }

        it { expect(result).to be_failure }
        it { expect(result).to be_kind_of(Dry::Monads::Result::Failure) }
        it { expect(failure.success?).to be false }

        it { expect(failure.errors).not_to be_nil }
      end

      context "with the required attributes" do
        let(:success) { result.success }

        it { expect(result).to be_success }
        it { expect(success.valid?).to be true }
        it { expect(success).to be_kind_of(Activity) }
        it { expect(success.persisted?).to be true }
      end

      context "when #object_ids set" do
        let(:success) { result.success }

        let(:attributes) do
          { actor_id: actor.guid,
            activity_object_id: activity_object.id,
            object_ids: object_ids,
            verb: verb }
        end

        let(:public_privacy) do
          Socializer::Audience.privacy.public.value
        end

        let(:circles_privacy) do
          Socializer::Audience.privacy.circles.value
        end

        let(:limited_privacy) do
          Socializer::Audience.privacy.limited.value
        end

        let(:public_audience) do
          success.audiences.where(privacy: "public")
        end

        let(:circles_audience) do
          success.audiences.where(privacy: "circles")
        end

        let(:limited_audience) do
          success.audiences.where(privacy: "limited")
        end

        context "with a String" do
          let(:object_ids) { public_privacy }

          it { expect(success.persisted?).to eq(true) }
          it { expect(public_audience.present?).to eq(true) }
          it { expect(circles_audience.present?).to eq(false) }
        end

        context "with an Array" do
          let(:object_ids) { [public_privacy, circles_privacy] }

          it { expect(success.persisted?).to eq(true) }
          it { expect(public_audience.present?).to eq(true) }
          it { expect(circles_audience.present?).to eq(true) }
        end

        context "with limited privacy" do
          before do
            AddDefaultCircles.call(person: actor)
          end

          let(:family) do
            Circle.find_by(author_id: actor.guid, display_name: "Family")
          end

          let(:object_ids) { [family.id] }

          it { expect(success.persisted?).to eq(true) }
          it { expect(limited_audience.present?).to eq(true) }
        end
      end
    end

    context "with .create" do
      let(:verb) { build(:verb, display_name: "post") }
      let(:result) { activity.create(attributes) }

      context "with valid attributes" do
        let(:success) { result.success }

        it { expect(result).to be_success }
        it { expect(success.persisted?).to eq(true) }
      end

      context "with invalid attributes" do
        let(:attributes) {}
        let(:failure) { result.failure }

        it { expect(result).to be_failure }
        it { expect(failure.persisted?).to eq(false) }
      end
    end
  end
end
