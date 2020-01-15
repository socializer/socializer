# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity::Services::Share, type: :service do
    let(:activity_object) { create(:activity_object) }
    let(:actor) { create(:person) }
    let(:share) { described_class.new(actor: actor) }

    let(:public_privacy) do
      Socializer::Audience.privacy.find_value(:public).value
    end

    let(:object_ids) { public_privacy }

    let(:share_attributes) do
      ActionController::Parameters.new(
        activity_id: activity_object.id,
        object_ids: object_ids,
        content: "Share"
      ).to_unsafe_hash.symbolize_keys
    end

    let(:results) do
      share.call(params: share_attributes).success[:activity]
    end

    it { expect(results.persisted?).to eq(true) }
    it { expect(results.actor_id).to eq(actor.guid) }
    it { expect(results.activity_object_id).to eq(activity_object.id) }
    it { expect(results.verb.display_name).to eq("share") }
    it { expect(results.activity_field_content).to eq("Share") }

    context "with no content" do
      let(:share_attributes) do
        ActionController::Parameters.new(
          activity_id: activity_object.id,
          object_ids: object_ids,
          content: nil
        ).to_unsafe_hash.symbolize_keys
      end

      let(:results) do
        share.call(params: share_attributes).success[:activity]
      end

      it { expect(results.activity_field_content).to eq(nil) }
    end

    context "when #object_ids is nil" do
      let(:object_ids) { "" }
      let(:result) { share.call(params: share_attributes) }
      let(:errors) { result.failure[:errors] }
      let(:results) do
        share.call(params: share_attributes).failure[:activity]
      end

      it { expect(results.persisted?).to eq(false) }
    end

    context "when #object_ids is an array of non strings" do
      let(:object_ids) { [1, 2, 3] }
      let(:results) do
        share.call(params: share_attributes).failure[:activity]
      end

      it { expect(results.persisted?).to eq(false) }
    end

    context "when #object_ids is an array of strings" do
      let(:object_ids) { [public_privacy, circles_privacy] }

      let(:circles_privacy) do
        Socializer::Audience.privacy.find_value(:circles).value
      end

      let(:results) do
        share.call(params: share_attributes).success[:activity]
      end

      let(:public_audience) { results.audiences.where(privacy: "public") }
      let(:circles_audience) { results.audiences.where(privacy: "circles") }

      it { expect(results.persisted?).to eq(true) }
      it do
        byebug
        expect(public_audience.present?).to eq(true)
      end
      # it { expect(public_audience.present?).to eq(true) }
      it { expect(circles_audience.present?).to eq(true) }
    end

    context "with .create" do
      context "with valid attributes" do
        let(:result) { share.create(attributes) }
        let(:success) { result.success }
        let(:verb) { create(:verb, display_name: "share") }

        let(:attributes) do
          { actor_id: actor.guid,
            activity_object_id: activity_object.id,
            object_ids: object_ids,
            verb: verb,
            content: "Share" }
        end

        it { expect(result).to be_success }
        it { expect(success.persisted?).to eq(true) }
      end

      context "with invalid attributes" do
        let(:result) { share.create({}) }
        let(:failure) { result.failure }

        it { expect(result).to be_failure }
        it { expect(failure.persisted?).to eq(false) }
      end
    end
  end
end
